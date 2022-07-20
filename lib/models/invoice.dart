import 'package:json_annotation/json_annotation.dart';
import './cart_info.dart';

part 'invoice.g.dart';

@JsonSerializable(explicitToJson: true)
class Invoice {
  List<CartInfo> cartInfo;
  String username;
  String orderDate;
  int total;

  Invoice(this.cartInfo, this.username, this.orderDate, this.total);

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}