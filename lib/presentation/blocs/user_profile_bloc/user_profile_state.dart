part of 'user_profile_bloc.dart';

class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileStateLoading extends UserProfileState {
  const UserProfileStateLoading();

  @override
  List<Object> get props => [];
}

class UserProfileLoaded extends UserProfileState {
  final Profile profile;
  const UserProfileLoaded({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UserProfileListLoaded extends UserProfileState {
  final List<Profile> profiles;
  const UserProfileListLoaded({required this.profiles});

  @override
  List<Object> get props => [profiles];
}

class UserProfileStateError extends UserProfileState {
  final String message;
  const UserProfileStateError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserProfileStateCreated extends UserProfileState {
  final Profile profile;
  const UserProfileStateCreated({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UserProfileDeleted extends UserProfileState {
  const UserProfileDeleted();

  @override
  List<Object> get props => [];
}
