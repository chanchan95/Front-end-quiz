import '../repositories/auth_repository.dart';

class ValidateAdmin {
  final AuthRepository _authRepository;

  ValidateAdmin({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Map<String, dynamic>> call() {
    return _authRepository.validateAdmin();
  }
}