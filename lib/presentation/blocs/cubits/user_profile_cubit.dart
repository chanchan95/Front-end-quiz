import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_quiz_frontend/domain/entities/profile.dart';

class UserProfileCubit extends Cubit<Profile>
{
  UserProfileCubit() : super(const Profile.empty());

  void setProfile(Profile profile) => emit(profile);

  void setFullName(String fullName)
  {
    final profile = state.copyWith(fullName: fullName);
    emit(profile);
  }

  void setEmail(String email)
  {
    final profile = state.copyWith(email: email);
    emit(profile);
  }

  void setStudentCode(String studentCode)
  {
    final profile = state.copyWith(studentCode: studentCode);
    emit(profile);
  }

  void setStudentClass(String studentClass)
  {
    final profile = state.copyWith(studentClass: studentClass);
    emit(profile);
  }
  void setDob(String dob)
  {
    final profile = state.copyWith(dob: dob);
    emit(profile);
  }
  void setAddress(String address)
  {
    final profile = state.copyWith(address: address);
    emit(profile);
  }
  
  
}