class AuthErrorMapper {
  static String map(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Xử lý các lỗi đăng nhập sai thông tin
    if (errorString.contains('user-not-found') ||
        errorString.contains('wrong-password') ||
        errorString.contains('invalid-credential') ||
        errorString.contains('invalid-email-password') ||
        errorString.contains('the supplied auth credential is incorrect')) {
      return 'Tài khoản sai mật khẩu hoặc email';
    }

    if (errorString.contains('email-already-in-use')) {
      return 'Email đã được sử dụng';
    }

    if (errorString.contains('weak-password')) {
      return 'Mật khẩu quá yếu (tối thiểu 6 ký tự)';
    }

    if (errorString.contains('invalid-email')) {
      return 'Email không hợp lệ';
    }

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Lỗi kết nối mạng. Vui lòng thử lại';
    }

    if (errorString.contains('too-many-requests')) {
      return 'Quá nhiều lần thử. Vui lòng thử lại sau';
    }

    if (errorString.contains('account_disabled')) {
      return 'Tài khoản đã bị khóa';
    }

    return error.toString().replaceAll('Exception: ', '');
  }
}
