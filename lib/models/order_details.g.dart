// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) {
  return OrderDetails(
    id: json['id'] as int,
    orderId: json['orderId'] as int,
    ticketId: json['ticketId'] as int,
    ticket: Ticket.fromJson(json['ticket'] as Map<String, dynamic>),
    quantity: json['quantity'] as int,
  );
}

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'ticketId': instance.ticketId,
      'ticket': instance.ticket.toJson(),
      'quantity': instance.quantity,
    };
