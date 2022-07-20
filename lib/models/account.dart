import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String password;
  final String phone;
  final int role_id;

  Account({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.password,
    required this.phone,
    required this.role_id,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

}
