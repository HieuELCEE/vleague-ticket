// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    id: json['id'] as int,
    accountId: json['accountId'] as int,
    status: json['status'] as int,
    total: (json['total'] as num).toDouble(),
    orderDate: DateTime.parse(json['orderDate'] as String),
    account: Account.fromJson(json['account'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'status': instance.status,
      'total': instance.total,
      'orderDate': instance.orderDate.toIso8601String(),
      'account': instance.account.toJson(),
    };
