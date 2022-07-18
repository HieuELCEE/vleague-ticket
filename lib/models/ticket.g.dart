// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) {
  return Ticket(
    id: json['id'] as int,
    matchId: json['matchId'] as int,
    areaId: json['areaId'] as int,
    amount: json['amount'] as int,
    price: (json['price'] as num).toDouble(),
    area: Area.fromJson(json['area'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'id': instance.id,
      'matchId': instance.matchId,
      'areaId': instance.areaId,
      'amount': instance.amount,
      'price': instance.price,
      'area': instance.area.toJson(),
    };
