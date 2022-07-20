import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import './account.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order with ChangeNotifier{
  final int id;
  final int accountId;
  final int status;
  final double total;
  final DateTime orderDate;
  final Account account;

  Order({
    required this.id,
    required this.accountId,
    required this.status,
    required this.total,
    required this.orderDate,
    required this.account,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
