class Validator {
  static String? isEmail(String email) {
    if (email.isEmpty) {
      return null;
    }
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  static String? isPassword(String password) {
    if (password.isEmpty) {
      return null;
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? isName(String name) {
    if (name.isEmpty) {
      return null;
    }
    if (!RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$").hasMatch(name)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  static String? isConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return null;
    }
    if (password != confirmPassword) {
      return 'Password does not match';
    }
    return null;
  }
}