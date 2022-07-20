import './order.dart';

class OrderList {
  List<Order> orders;

  OrderList({required this.orders});

  factory OrderList.fromJson(List<dynamic> json) {
    List<Order> orderList = <Order>[];
    orderList = json.map((e) => Order.fromJson(e)).toList();
    return new OrderList(orders: orderList);
  }
}