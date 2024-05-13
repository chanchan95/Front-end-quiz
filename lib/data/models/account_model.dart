import '../../domain/entities/account.dart';

class AccountModel extends Account {
  AccountModel({
    required super.email,
    required super.password,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory AccountModel.fromEntity(Account account) {
    return AccountModel(
      email: account.email,
      password: account.password,
    );
  }
}