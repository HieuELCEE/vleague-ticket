import './order_details.dart';

class OrderDetailsList {
  List<OrderDetails> orderDetailsList;

  OrderDetailsList({required this.orderDetailsList});

  factory OrderDetailsList.fromJson(List<dynamic> json) {
    List<OrderDetails> orderDetails = <OrderDetails>[];
    orderDetails = json.map((e) => OrderDetails.fromJson(e)).toList();
    return new OrderDetailsList(orderDetailsList: orderDetails);
  }
}