// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartInfo _$CartInfoFromJson(Map<String, dynamic> json) {
  return CartInfo(
    quantity: json['quantity'] as int,
    ticketId: json['ticketId'] as int,
  );
}

Map<String, dynamic> _$CartInfoToJson(CartInfo instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'ticketId': instance.ticketId,
    };
