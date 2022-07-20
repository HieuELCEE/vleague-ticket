// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return Invoice(
    (json['cartInfo'] as List<dynamic>)
        .map((e) => CartInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['username'] as String,
    json['orderDate'] as String,
    json['total'] as int,
  );
}

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'cartInfo': instance.cartInfo.map((e) => e.toJson()).toList(),
      'username': instance.username,
      'orderDate': instance.orderDate,
      'total': instance.total,
    };
