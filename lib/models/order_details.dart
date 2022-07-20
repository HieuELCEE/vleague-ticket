import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import './ticket.dart';

part 'order_details.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDetails with ChangeNotifier {
  final int id;
  final int orderId;
  final int ticketId;
  final Ticket ticket;
  final int quantity;

  OrderDetails({
    required this.id,
    required this.orderId,
    required this.ticketId,
    required this.ticket,
    required this.quantity,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => _$OrderDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}
