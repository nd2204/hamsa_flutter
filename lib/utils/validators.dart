class Validators {
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidDisplayName(String displayName) {
    return displayName.trim().isNotEmpty;
  }

  static String? emailError(String email) {
    if (email.isEmpty) return null;
    if (!isValidEmail(email)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? passwordError(String password) {
    if (password.isEmpty) return null;
    if (!isValidPassword(password)) {
      return 'Mật khẩu tối thiểu 6 ký tự';
    }
    return null;
  }

  static String? displayNameError(String displayName) {
    if (displayName.isEmpty) return null;
    if (!isValidDisplayName(displayName)) {
      return 'Tên hiển thị không được để trống';
    }
    return null;
  }

  static String? confirmPasswordError(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return null;
    if (password != confirmPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }
}
