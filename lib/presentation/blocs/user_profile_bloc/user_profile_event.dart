part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

}

class FetchUserProfileEvent extends UserProfileEvent {
  final String id;
  const FetchUserProfileEvent({required this.id});
  @override
  List<Object> get props => [id];
}

class FetchUserProfilesEvent extends UserProfileEvent {
  final String keyWord;
  final String choice;
  const FetchUserProfilesEvent({required this.keyWord, required this.choice});
  @override
  List<Object> get props => [keyWord, choice];
}

class CreateUserProfileEvent extends UserProfileEvent {
  final Profile profile;
  const CreateUserProfileEvent({required this.profile});
  @override
  List<Object> get props => [profile];
}

class UpdateUserProfileEvent extends UserProfileEvent {
  final Profile profile;
  const UpdateUserProfileEvent({required this.profile});
  @override
  List<Object> get props => [profile];
}

class DeleteUserProfileEvent extends UserProfileEvent {
  final String id;
  const DeleteUserProfileEvent({required this.id});
  @override
  List<Object> get props => [id];
}