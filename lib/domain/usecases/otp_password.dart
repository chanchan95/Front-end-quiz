import '../repositories/auth_repository.dart';

class OtpPassword
{
  final AuthRepository _authRepository;

  OtpPassword({required AuthRepository authRepository}) : _authRepository = authRepository;
  Future<Map<String, dynamic>> call(String email, String otp) {
    return _authRepository.otpPassword(email, otp);
  }
}