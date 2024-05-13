// import '../entities/account.dart';
import '../repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository _authRepository;

  ForgotPassword({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Map<String, dynamic>> call(String email) {
    return _authRepository.forgotPassword(email);
  }
}