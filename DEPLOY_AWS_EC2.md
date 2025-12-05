# ☁️ Hướng dẫn Deploy FlavorVerse lên AWS EC2 (Free Tier)

## 🎯 AWS EC2 Free Tier

- **750 giờ/tháng miễn phí** trong 12 tháng đầu (đủ cho 1 instance chạy 24/7)
- **t2.micro instance** (1 vCPU, 1 GB RAM)
- **30 GB EBS storage**
- Sau 12 tháng: ~$8-10/tháng

---

## 📋 Chọn phương án Deploy

### 🐳 Phương án 1: Docker (Khuyến nghị - Dễ nhất)
- ✅ Setup nhanh (~15 phút)
- ✅ Không cần cài Python, MySQL, Nginx thủ công
- ✅ Dễ maintain và update
- ⬇️ Xem phần **"Deploy với Docker"** bên dưới

### ⚙️ Phương án 2: Manual Setup
- ✅ Toàn quyền kiểm soát
- ✅ Hiểu rõ từng bước
- ⚠️ Setup lâu hơn (~1-2 giờ)
- ⬇️ Xem phần **"Deploy Manual"** bên dưới

---

# 🐳 PHƯƠNG ÁN 1: DEPLOY VỚI DOCKER

## Bước 1: Launch EC2 Instance

1. Truy cập: https://console.aws.amazon.com
2. Vào **EC2 Dashboard** → **Launch Instance**
3. Cấu hình:
   - **Name**: `flavorverse-server`
   - **AMI**: Ubuntu Server 22.04 LTS
   - **Instance Type**: t2.micro (Free tier)
   - **Key Pair**: Tạo mới `flavorverse-key` (download .pem file)
   - **Network Settings**: 
     - SSH (22): My IP
     - HTTP (80): Anywhere (0.0.0.0/0)
     - HTTPS (443): Anywhere (0.0.0.0/0)
   - **Storage**: 8 GB gp3
4. Click **Launch Instance**
5. Lưu **Public IPv4 address**

## Bước 2: SSH vào EC2

```bash
# Mac/Linux
chmod 400 flavorverse-key.pem
ssh -i flavorverse-key.pem ubuntu@<ec2-ip>

# Windows: Dùng PuTTY (convert .pem sang .ppk)
```

## Bước 3: Cài đặt Docker

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Logout và login lại
exit
# SSH lại vào server
```

## Bước 4: Clone Project

```bash
cd ~
git clone https://github.com/yourusername/CookBookG5.git
cd CookBookG5
```

## Bước 5: Tạo file .env

```bash
nano .env
```

Thêm nội dung:
```env
SECRET_KEY=your-secret-key-min-32-characters
MYSQL_ROOT_PASSWORD=your-secure-root-password
MYSQL_PASSWORD=your-secure-db-password
DEFAULT_ADMIN_USERNAME=admin
DEFAULT_ADMIN_PASSWORD=your-admin-password
DEFAULT_ADMIN_EMAIL=admin@example.com
```

**Tạo SECRET_KEY:**
```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```

## Bước 6: Build và Start

```bash
docker-compose build
docker-compose up -d
```

## Bước 7: Kiểm tra

```bash
# Xem status
docker-compose ps

# Xem logs
docker-compose logs -f

# Vào container để setup admin
docker exec -it flavorverse-web bash
cd /app
python
```

```python
from backend.mycookbook import app, db, User
from werkzeug.security import generate_password_hash

with app.app_context():
    admin = User.query.filter_by(username='admin').first()
    if not admin:
        admin = User(
            username='admin',
            email='admin@example.com',
            password_hash=generate_password_hash('your-admin-password'),
            is_admin=True
        )
        db.session.add(admin)
        db.session.commit()
        print("Admin created!")
```

## Bước 8: Test

Truy cập: `http://<ec2-ip>`

---

# ⚙️ PHƯƠNG ÁN 2: DEPLOY MANUAL

## Bước 1-2: Giống Docker (Launch EC2 và SSH)

Làm theo Bước 1-2 của phương án Docker ở trên.

## Bước 3: Cài đặt Dependencies

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Python
sudo apt install -y python3 python3-pip python3-venv

# Install MySQL
sudo apt install -y mysql-server
sudo mysql_secure_installation

# Install Nginx
sudo apt install -y nginx

# Install Git
sudo apt install -y git
```

## Bước 4: Setup MySQL

```bash
sudo mysql -u root -p
```

```sql
CREATE DATABASE Mycookbook_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'cookbook_user'@'localhost' IDENTIFIED BY 'your-password';
GRANT ALL PRIVILEGES ON Mycookbook_db.* TO 'cookbook_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## Bước 5: Clone và Setup Project

```bash
cd ~
git clone https://github.com/yourusername/CookBookG5.git
cd CookBookG5

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Create .env file
nano .env
```

Thêm vào `.env`:
```env
SECRET_KEY=your-secret-key
USE_MYSQL=1
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=cookbook_user
MYSQL_PASSWORD=your-password
MYSQL_DB=Mycookbook_db
DEFAULT_ADMIN_USERNAME=admin
DEFAULT_ADMIN_PASSWORD=your-admin-password
AUTO_IMPORT_DUMP=0
PORT=8000
```

```bash
# Create upload directories
mkdir -p frontend/static/uploads/profiles
mkdir -p frontend/static/uploads/recipes
chmod 755 frontend/static/uploads

# Import database
mysql -u cookbook_user -p Mycookbook_db < "Mycookbook_db (1).sql"
```

## Bước 6: Setup Gunicorn Service

```bash
sudo nano /etc/systemd/system/flavorverse.service
```

Thêm:
```ini
[Unit]
Description=FlavorVerse Gunicorn daemon
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/CookBookG5
Environment="PATH=/home/ubuntu/CookBookG5/venv/bin"
ExecStart=/home/ubuntu/CookBookG5/venv/bin/gunicorn --chdir backend mycookbook:app --bind 127.0.0.1:8000 --workers 2

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl start flavorverse
sudo systemctl enable flavorverse
sudo systemctl status flavorverse
```

## Bước 7: Cấu hình Nginx

```bash
sudo nano /etc/nginx/sites-available/flavorverse
```

Thêm:
```nginx
server {
    listen 80;
    server_name _;

    client_max_body_size 16M;

    location /static {
        alias /home/ubuntu/CookBookG5/frontend/static;
        expires 30d;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/flavorverse /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Bước 8: Setup Admin Account

```bash
cd ~/CookBookG5
source venv/bin/activate
python
```

```python
from backend.mycookbook import app, db, User
from werkzeug.security import generate_password_hash

with app.app_context():
    admin = User.query.filter_by(username='admin').first()
    if not admin:
        admin = User(
            username='admin',
            email='admin@example.com',
            password_hash=generate_password_hash('your-password'),
            is_admin=True
        )
        db.session.add(admin)
        db.session.commit()
        print("Admin created!")
```

## Bước 9: Test

Truy cập: `http://<ec2-ip>`

---

# 🔧 Quản lý và Maintenance

## Docker Commands

```bash
# Xem status
docker-compose ps

# Xem logs
docker-compose logs -f

# Restart
docker-compose restart

# Stop
docker-compose stop

# Update code
git pull && docker-compose build web && docker-compose up -d
```

## Manual Commands

```bash
# Restart services
sudo systemctl restart flavorverse
sudo systemctl restart nginx
sudo systemctl restart mysql

# Xem logs
sudo journalctl -u flavorverse -f
sudo tail -f /var/log/nginx/error.log

# Update code
cd ~/CookBookG5
git pull
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart flavorverse
```

---

# 🔒 Security Best Practices

## 1. Setup Firewall (UFW)

```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

## 2. Update System thường xuyên

```bash
sudo apt update && sudo apt upgrade -y
```

## 3. Setup SSL với Let's Encrypt (nếu có domain)

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## 4. Regular Backups

```bash
# Docker
docker exec flavorverse-db mysqldump -u cookbook_user -p Mycookbook_db > backup.sql

# Manual
mysqldump -u cookbook_user -p Mycookbook_db > backup.sql
```

---

# 🔧 Troubleshooting

## Lỗi: Cannot connect via SSH
- Kiểm tra Security Group cho phép SSH từ IP của bạn

## Lỗi: 502 Bad Gateway
- **Docker**: `docker-compose logs web`
- **Manual**: `sudo systemctl status flavorverse`

## Lỗi: Database connection failed
- Kiểm tra MySQL đã chạy: `sudo systemctl status mysql` (manual) hoặc `docker-compose ps db` (docker)
- Kiểm tra credentials trong `.env`

## Lỗi: Static files không load
- Kiểm tra quyền: `chmod -R 755 frontend/static`
- Kiểm tra Nginx config

---

# 💰 Quản lý Free Tier

## Kiểm tra Usage
1. Vào **AWS Billing Dashboard**
2. Xem **Free Tier Usage**
3. Đảm bảo không vượt:
   - 750 giờ EC2
   - 30 GB EBS storage
   - 2 million I/O requests

## Tips tiết kiệm
- Chỉ chạy 1 instance
- Monitor usage thường xuyên
- Stop instance khi không dùng (nếu cần)

---

# ✅ Checklist

## Docker
- [ ] Launch EC2 instance
- [ ] SSH vào server
- [ ] Cài Docker và Docker Compose
- [ ] Clone project
- [ ] Tạo file `.env`
- [ ] Build và start containers
- [ ] Setup admin account
- [ ] Test website

## Manual
- [ ] Launch EC2 instance
- [ ] SSH vào server
- [ ] Cài Python, MySQL, Nginx
- [ ] Setup MySQL database
- [ ] Clone project
- [ ] Tạo virtual environment
- [ ] Install dependencies
- [ ] Tạo file `.env`
- [ ] Setup Gunicorn service
- [ ] Cấu hình Nginx
- [ ] Setup admin account
- [ ] Test website

---

# 🎯 Kết quả

Website sẽ chạy tại: `http://<ec2-ip>` hoặc `https://your-domain.com` (nếu có SSL)

---

# 📞 Hỗ trợ

- AWS Docs: https://docs.aws.amazon.com/ec2
- Docker Docs: https://docs.docker.com
- Free Tier: https://aws.amazon.com/free

---

## 🎉 Hoàn thành!

Chúc bạn deploy thành công! ☁️
