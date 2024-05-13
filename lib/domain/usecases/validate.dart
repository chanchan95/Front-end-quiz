import 'package:ptit_quiz_frontend/domain/repositories/auth_repository.dart';

class Validate {
  final AuthRepository _authRepository;

  Validate({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Map<String, dynamic>> call() {
    return _authRepository.validate();
  }
}