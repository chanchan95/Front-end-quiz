import '../entities/account.dart';
import '../entities/profile.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository _authRepository;

  Register({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Map<String, dynamic>> call(Account account, Profile profile) {
    return _authRepository.register(account, profile);
  }
}