// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(
    id: json['id'] as int,
    firstname: json['firstname'] as String,
    lastname: json['lastname'] as String,
    username: json['username'] as String,
    password: json['password'] as String,
    phone: json['phone'] as String,
    role_id: json['role_id'] as int,
  );
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'username': instance.username,
      'password': instance.password,
      'phone': instance.phone,
      'role_id': instance.role_id,
    };
