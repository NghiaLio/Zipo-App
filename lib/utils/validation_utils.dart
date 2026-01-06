class ValidationUtils {
  // Regular expression for email validation
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Regular expression for Vietnamese phone number validation
  // Supports formats: +84xxxxxxxxx, 84xxxxxxxxx, 0xxxxxxxxx
  static final RegExp _phoneRegExp = RegExp(
    r'^(?:\+84|84|0)[3|5|7|8|9][0-9]{8}$',
  );

  /// Validates if the given string is a valid email address
  /// Returns true if valid, false otherwise
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegExp.hasMatch(email.trim());
  }

  /// Validates if the given string is a valid Vietnamese phone number
  /// Supports formats:
  /// - +84xxxxxxxxx (international format)
  /// - 84xxxxxxxxx (without plus)
  /// - 0xxxxxxxxx (local format)
  /// Returns true if valid, false otherwise
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;
    return _phoneRegExp.hasMatch(phone.trim());
  }
}
