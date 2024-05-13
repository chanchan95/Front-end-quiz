part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthLoginEvent extends AuthEvent {
  final Account account;
  const AuthLoginEvent({required this.account});

  @override
  List<Object> get props => [account];
}

class AuthAdminLoginEvent extends AuthEvent {
  final Account account;
  const AuthAdminLoginEvent({required this.account});

  @override
  List<Object> get props => [account];
}

class AuthRegisterEvent extends AuthEvent {
  final Account account;
  final Profile profile;
  const AuthRegisterEvent({required this.account, required this.profile});

  @override
  List<Object> get props => [account];
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
  @override
  List<Object> get props => [];
}

class AuthValidateEvent extends AuthEvent {
  const AuthValidateEvent();
  @override
  List<Object> get props => [];
}

class AuthForgotPasswordEvent extends AuthEvent {
  final String email;
  const AuthForgotPasswordEvent({required this.email});
  @override
  List<Object> get props => [email];
}

class AuthOtpPasswordEvent extends AuthEvent {
  final String email;
  final String otp;
  const AuthOtpPasswordEvent({required this.email, required this.otp});
  @override
  List<Object> get props => [email, otp];
}

class AuthResetPasswordEvent extends AuthEvent {
  final String password;
  final String tokenUser;
  const AuthResetPasswordEvent(
      {required this.password, required this.tokenUser});
  @override
  List<Object> get props => [password, tokenUser];
}
