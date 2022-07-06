import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import './area.dart';

part 'ticket.g.dart';

@JsonSerializable(explicitToJson: true)
class Ticket with ChangeNotifier{
  int id;
  int matchId;
  int areaId;
  int amount;
  double price;
  Area area;

  Ticket({
    required this.id,
    required this.matchId,
    required this.areaId,
    required this.amount,
    required this.price,
    required this.area,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}
