class Profile {
  final String? id;
  final String? fullName;
  final String? email;
  final String? photoUrl;
  final String? studentCode;
  final String? studentClass;
  final String? dob;
  final String? address;
  final String? role;
  final String? password;
  Profile(

      {
      this.id,
      this.fullName,
      this.email,
      this.photoUrl,
      this.studentCode,
      this.studentClass,
      this.dob,
      this.address,
      this.role = 'user',
      this.password,
      });

  Profile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? photoUrl,
    String? studentCode,
    String? studentClass,
    String? dob,
    String? address,
    String? role,
    String? password,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      studentCode: studentCode ?? this.studentCode,
      studentClass: studentClass ?? this.studentClass,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      role: role ?? this.role,
      password: password ?? this.password,
    );
  }
  // empty profile
  const Profile.empty()
      : id = '',
        fullName = '',
        email = '',
        photoUrl = '',
        studentCode = '',
        studentClass = '',
        dob = '',
        address = '',
        role = 'user',
        password = '';
}
