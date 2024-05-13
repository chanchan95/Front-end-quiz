import '../entities/account.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository _authRepository;

  Login({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Map<String, dynamic>> call(Account account) {
    return _authRepository.login(account);
  }
}