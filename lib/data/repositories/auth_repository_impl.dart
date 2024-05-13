import '../models/account_model.dart';
import '../models/profile_model.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/local_data.dart';
import '../providers/remote_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalData localData;
  final RemoteData remoteData;

  AuthRepositoryImpl({required this.localData, required this.remoteData});

  @override
  Future<Map<String, dynamic>> login(Account account) async {
    final response = await remoteData.login(AccountModel.fromEntity(account));
    await localData.saveToken(response['access_token']);
    // await localData.saveRefreshToken(response['refresh_token']);
    return response;
  }

  @override
  Future<Map<String, dynamic>> adminLogin(Account account) async {
    final response =
        await remoteData.adminLogin(AccountModel.fromEntity(account));
    await localData.saveToken(response['access_token']);
    // await localData.saveRefreshToken(response['refresh_token']);
    return response;
  }

  @override
  Future<Map<String, dynamic>> register(
      Account account, Profile profile) async {
    final response = await remoteData.register(
        AccountModel.fromEntity(account), ProfileModel.fromEntity(profile));
    await localData.saveToken(response['access_token']);
    // await localData.saveRefreshToken(response['refresh_token']);
    return response;
  }

  @override
  Future<void> logout() async {
    await localData.deleteToken();
    await localData.deleteRefreshToken();
  }

  @override
  Future<Map<String, dynamic>> validate() async {
    return await remoteData.validate();
  }

  @override
  Future<Map<String, dynamic>> validateAdmin() async {
    return await remoteData.validateAdmin();
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await remoteData.forgotPassword(email);
  }

  @override
  Future<Map<String, dynamic>> otpPassword(String email, String otp) async {
    return await remoteData.otpPassword(email, otp);
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      String password, String tokenUser) async {
    return await remoteData.resetPassword(password, tokenUser);
  }
}
