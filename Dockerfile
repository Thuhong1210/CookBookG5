# Dockerfile cho FlavorVerse
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (for better caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Create upload directories
RUN mkdir -p frontend/static/uploads/profiles \
    frontend/static/uploads/recipes && \
    chmod -R 755 frontend/static/uploads

# Expose port
EXPOSE 8000

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=backend/mycookbook/__init__.py

# Run Gunicorn
CMD ["gunicorn", "--chdir", "backend", "mycookbook:app", "--bind", "0.0.0.0:8000", "--workers", "2", "--timeout", "120"]

