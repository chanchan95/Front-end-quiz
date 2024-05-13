import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ptit_quiz_frontend/domain/entities/profile.dart';
import 'package:ptit_quiz_frontend/domain/usecases/create_user.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_users_profiles.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  late getUsersProfiles _getUsersProfiles;
  late CreateUser _createProfile;
  // late DeleteProfile _deleteProfile;

  UserProfileBloc({
    required getUsersProfiles getUsersProfiles,
    required CreateUser createProfile,
    // required DeleteProfile deleteProfile,
  }) : super(const UserProfileState()) {
    _getUsersProfiles = getUsersProfiles;
    _createProfile = createProfile;
    // _deleteProfile = deleteProfile;
    on<FetchUserProfilesEvent>(_onFetchUsersProfiles);
    on<CreateUserProfileEvent>(_onCreateProfile);
    // on<DeleteProfileEvent>(_onDeleteProfile);
  }

  Future<void> _onFetchUsersProfiles(
      FetchUserProfilesEvent event, Emitter<UserProfileState> emit) async {
    emit(const UserProfileStateLoading());
    try {
      final profiles = await _getUsersProfiles(event.keyWord, event.choice);
      emit(UserProfileListLoaded(profiles: profiles));
    } catch (e) {
      emit(UserProfileStateError(message: e.toString()));
    }
  }

  Future<void> _onCreateProfile(
      CreateUserProfileEvent event, Emitter<UserProfileState> emit) async {
    emit(const UserProfileStateLoading());
    try {
      await _createProfile(event.profile);
      emit(UserProfileStateCreated(profile: event.profile));
    } catch (e) {
      emit(UserProfileStateError(message: e.toString()));
    }
  }
}
