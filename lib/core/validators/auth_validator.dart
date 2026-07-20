class AuthValidator {
  AuthValidator._();

  static String? identifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your identifier';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }
}
