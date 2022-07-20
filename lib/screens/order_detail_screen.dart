import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vleague_ticket_v2/models/order.dart';

import '../providers/order_detail_provider.dart';
import '../widgets/order_detail_list.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/order_detail_screen';
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  var _isLoading = false;
  var _init = true;

  // @override
  // Future<void> didChangeDependencies() async{
  //   if (_init) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     var orderId = ModalRoute.of(context)!.settings.arguments as int;
  //     await Provider.of<OrderDetailProvider>(context, listen: false).fetchOrderDetailByOrderId(orderId).then((_) {
  //       if (!mounted) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     });
  //   }
  //   _init = false;
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      var orderId = ModalRoute.of(context)!.settings.arguments as int;
      await Provider.of<OrderDetailProvider>(context, listen: false).fetchOrderDetailByOrderId(orderId);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orderId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Invoice'),),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : OrderDetailListView(orderId: orderId),
    );
  }
}
