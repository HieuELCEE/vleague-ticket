import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vleague_ticket_v2/providers/order_detail_provider.dart';


import './order_item.dart';
import '../providers/orders_provider.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({Key? key}) : super(key: key);

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  Future<void> _refreshOrder(BuildContext context) async {
    await Provider.of<OrdersProvider>(context, listen: false).forceRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrdersProvider>(context, listen: true);
    var orderList = orderProvider.orders;
    return RefreshIndicator(
      onRefresh: () => _refreshOrder(context),
      child: Column(
        children: [
          orderList.length == 0 ? Center(child: Text('No record'),) :
          Expanded(
            child: Consumer<OrdersProvider>(
              builder: (ctx, orderProvider, child) =>
              ListView.builder(
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: orderList[index],
                  child: OrderItem(orderId: orderList[index].id,),
                ),
                itemCount: orderList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
