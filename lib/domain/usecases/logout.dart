import 'package:ptit_quiz_frontend/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository _authRepository;

  Logout({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> call() {
    return _authRepository.logout();
  }
}