#!/usr/bin/env python3
"""
Script to translate Vietnamese text to English in Admin.html
"""

translations = {
    # Buttons and Actions
    "Kiểm tra kết nối": "Check Connection",
    "Đã kiểm tra": "Checked",
    "Lỗi, thử lại": "Error, try again",
    "Lọc": "Filter",
    "Xoá": "Delete",
    "Thu hồi quyền": "Revoke Permission",
    "Cấp quyền": "Grant Permission",
    
    # Headers and Titles
    "Quản lý người dùng": "User Management",
    "Quản lý các công thức do người dùng gửi": "Manage user-submitted recipes",
    "Bình luận mới nhất": "Latest Comments",
    "Theo dõi thảo luận từ cộng đồng": "Monitor community discussions",
    "Thông báo hệ thống": "System Notifications",
    "Danh sách thông báo gần đây": "Recent notifications list",
    
    # Table Headers
    "Tên": "Name",
    "Vai trò": "Role",
    "Thao tác": "Actions",
    "Người nhận": "Recipient",
    "Người thực hiện": "Actor",
    "Loại": "Type",
    "Nội dung": "Content",
    "Thời gian": "Time",
    
    # Status Messages
    "↑ tăng so với tháng trước": "↑ increase from last month",
    "↑ duyệt gần đây": "↑ recently approved",
    "không đổi": "no change",
    "Chưa có hoạt động gần đây.": "No recent activity.",
    "Không có công thức gần đây.": "No recent recipes.",
    "Chưa có người dùng.": "No users yet.",
    "Không có công thức phù hợp.": "No matching recipes.",
    "Chưa có bình luận.": "No comments yet.",
    "Không có thông báo.": "No notifications.",
    "Chưa chọn công thức": "No recipes selected",
    
    # Other Text
    "Đã xoá": "Deleted",
    "Khác": "Other",
    "Ẩn danh": "Anonymous",
    "trên": "on",
    "Đang đăng nhập": "Currently logged in",
    "Cấp quyền admin hoặc xoá tài khoản": "Grant admin rights or delete account",
    
    # Confirmation Messages
    "Xoá người dùng": "Delete user",
    "Xoá công thức": "Delete recipe",
    "Xoá bình luận này?": "Delete this comment?",
    
    # Comments
    "Phần Reports": "Reports Section",
    "Phần Categories & Tags": "Categories & Tags Section",
}

def translate_file(input_file, output_file):
    """Translate Vietnamese to English in the file"""
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Replace all translations
    for vietnamese, english in translations.items():
        content = content.replace(vietnamese, english)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Translation complete! Output saved to {output_file}")
    print(f"Replaced {len(translations)} phrases")

if __name__ == "__main__":
    input_file = "/Users/admin/Documents/GitHub/CookBookG5/frontend/templates/Admin.html"
    output_file = "/Users/admin/Documents/GitHub/CookBookG5/frontend/templates/Admin.html"
    translate_file(input_file, output_file)
