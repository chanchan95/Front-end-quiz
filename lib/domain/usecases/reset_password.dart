import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository _authRepository;

  ResetPassword({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Map<String, dynamic>> call(String password, String tokenUser) {
    return _authRepository.resetPassword(password, tokenUser);
  }
}
