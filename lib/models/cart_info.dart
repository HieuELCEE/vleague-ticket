import 'package:json_annotation/json_annotation.dart';

part 'cart_info.g.dart';

@JsonSerializable()
class CartInfo {
  int quantity;
  int ticketId;

  CartInfo({required this.quantity, required this.ticketId});

  factory CartInfo.fromJson(Map<String, dynamic> json) => _$CartInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CartInfoToJson(this);
}
