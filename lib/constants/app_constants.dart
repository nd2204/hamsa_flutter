import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const primaryColor = Color(0xFF5B4BFF);
  static const backgroundColor = Color(0xFFF3F6FF);

  // Dimensions
  static const double maxFormWidth = 420.0;
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;

  // Validation
  static const int minPasswordLength = 6;
}

class AppStrings {
  // Login
  static const loginTitle = 'Đăng nhập';
  static const loginSubtitle = 'Chào mừng trở lại!';
  static const signUpTitle = 'Đăng ký';
  static const signUpSubtitle = 'Tạo tài khoản mới';

  // Form labels
  static const emailLabel = 'Email';
  static const passwordLabel = 'Mật khẩu';
  static const displayNameLabel = 'Tên hiển thị';
  static const confirmPasswordLabel = 'Xác nhận mật khẩu';

  // Form hints
  static const displayNameHint = 'Nhập họ và tên';
  static const emailHint = 'your.email@example.com';
  static const passwordHint = '••••••••';

  // Buttons
  static const loginButton = 'Đăng nhập';
  static const signUpButton = 'Đăng ký';

  // Messages
  static const loginSuccess = 'Đăng nhập thành công!';
  static const signUpSuccess = 'Đăng ký thành công!';
  static const fillAllFields = 'Vui lòng nhập đầy đủ thông tin';

  // Navigation
  static const noAccount = 'Chưa có tài khoản? ';
  static const hasAccount = 'Đã có tài khoản? ';
  static const signUpNow = 'Đăng ký ngay';
  static const loginNow = 'Đăng nhập';

  // Profile
  static const appTitle = 'Task Manager';
  static const defaultUserName = 'User';
  static const logoutButtonTitle = 'Đăng Xuất';
  static const profileTitle = 'Thông tin cá nhân';
  static const cancelButton = 'Hủy';
  static const saveChangesButton = 'Lưu thay đổi';
  static const editButton = 'Chỉnh sửa';
  static const userNotFound = 'Không tìm thấy thông tin người dùng';
  static const statsTitle = 'Thống kê';
  static const userIdLabel = 'ID Người dùng';
  static const statusLabel = 'Trạng thái';
  static const activeStatus = 'Hoạt động';
  static const accountTypeLabel = 'Loại tài khoản';
  static const userAccountType = 'Người dùng';
  static const fullNameLabel = 'Họ và tên';
  static const joinDateLabel = 'Ngày tham gia';
  static const notAvailable = 'N/A';
  static const saveSuccessMessage = 'Đã lưu thay đổi thành công';
  static const signOutConfirmTitle = 'Xác nhận đăng xuất';
  static const signOutConfirmMessage = 'Bạn có chắc chắn muốn đăng xuất?';
  static const signOutButton = 'Đăng xuất';

  // Home
  static const selectedStatus = "Tất cả";
  static const selectedSort = "Mới nhất";
  static const taskUpdated = "Đã cập nhật task";
  static const taskDeleted = "Đã xóa task";
  static const taskProgressTitle = "Tiến độ hoàn thành";
  static const noTask = "Không có task nào";

  // Task
  static const saveTaskButtonTitle = "Lưu Task";
  static const createTaskButtonTitle = "Tạo Task";

  // etc
  static const goBackTitle = "Quay lại";
}
