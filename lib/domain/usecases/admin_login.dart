import '../entities/account.dart';
import '../repositories/auth_repository.dart';

class AdminLogin {
  final AuthRepository _authRepository;

  AdminLogin({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Map<String, dynamic>> call(Account account) {
    return _authRepository.adminLogin(account);
  }
}