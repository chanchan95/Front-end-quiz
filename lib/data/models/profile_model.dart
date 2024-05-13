import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    super.fullName,
    super.email,
    super.photoUrl,
    super.studentCode,
    super.studentClass,
    super.dob,
    super.address,
    super.role = 'user',
    super.password,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'],
      email: json['email'],
      studentCode: json['student_code'],
      studentClass: json['student_class'],
      dob: json['dob'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'student_code': studentCode,
      'student_class': studentClass,
      'dob': dob,
      'address': address,
      'role': role,
    };
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      fullName: profile.fullName,
      email: profile.email,
      // photoUrl: profile.photoUrl,
      studentCode: profile.studentCode,
      studentClass: profile.studentClass,
      dob: profile.dob,
      address: profile.address,
      // role: profile.role,
      password: profile.password,
    );
  }

  Map<String, dynamic> toJsonCreate(){
  return {
    'fullName': fullName,
    'student_code': studentCode,
    'student_class': studentClass,
    'dob': dob,
    'address': address,
    'email': email,
    'password': password,
  };
}

    factory ProfileModel.fromJsonCreate(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['user']['fullName'],
      email: json['user']['email'],
      studentCode: json['user']['student_code'],
      studentClass: json['user']['student_class'],
      dob: json['user']['dob'],
      address: json['user']['address'],
    );
  }
}