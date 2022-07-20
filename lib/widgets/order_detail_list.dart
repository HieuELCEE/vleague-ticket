import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_detail_provider.dart';
import './order_detail_item.dart';

class OrderDetailListView extends StatelessWidget {
  final orderId;
  const OrderDetailListView({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orderDetailProvider = Provider.of<OrderDetailProvider>(context, listen: false);
    var orderDetailList = orderDetailProvider.orderDetailList;
    return ListView.builder(itemBuilder: (ctx, index) => OrderDetailItem(areaName: orderDetailList[index].ticket.area.areaName, quantity: orderDetailList[index].quantity, price: orderDetailList[index].ticket.price), itemCount: orderDetailList.length,);
  }
}
