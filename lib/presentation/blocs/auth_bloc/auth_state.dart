part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();

  @override
  List<Object> get props => [];
}

class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated();

  @override
  List<Object> get props => [];
}

class AuthStateAdminAuthenticated extends AuthState {
  const AuthStateAdminAuthenticated();

  @override
  List<Object> get props => [];
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();

  @override
  List<Object> get props => [];
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthStateForgotPassword extends AuthState {
  const AuthStateForgotPassword();

  @override
  List<Object> get props => [];
}

class AuthStateOtpPassword extends AuthState {
  final String tokenUser;
  const AuthStateOtpPassword({required this.tokenUser});
  @override
  List<Object> get props => [];
}

class AuthStateResetPassword extends AuthState {
  const AuthStateResetPassword();

  @override
  List<Object> get props => [];
}