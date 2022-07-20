import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../util/date_util.dart';
import '../widgets/order_detail_item.dart';
import '../providers/order_detail_provider.dart';
import '../screens/order_detail_screen.dart';

class OrderItem extends StatefulWidget {
  final orderId;
  const OrderItem({required this.orderId});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {



  @override
  Widget build(BuildContext context) {
    var order = Provider.of<Order>(context);
    var date = order.orderDate;
    var dayOrder = DateUtil.convertDateToString(date, 'EEEE');
    final dateOfMatch = DateUtil.convertDateToString(date, 'dd/MM/yy');
    final time = DateUtil.convertDateToString(date, 'hh:mm aa');
    var orderDetailList = Provider.of<OrderDetailProvider>(context, listen: false)
        .fetchOrderDetailByOrderId(widget.orderId);
    var list = Provider.of<OrderDetailProvider>(context, listen: false).orderDetailList;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('$dateOfMatch at $time'),
            subtitle: Text('Total: \$${order.total}'),
            trailing: TextButton(onPressed: () {
              Navigator.of(context).pushNamed(OrderDetailScreen.routeName, arguments: widget.orderId);
            }, child: Text('See Detail'),),
          ),],
      ),
    );
  }
}
