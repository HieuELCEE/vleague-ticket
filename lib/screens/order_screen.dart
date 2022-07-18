import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/orders_provider.dart';
import '../widgets/orders_listview.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order_screen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _init = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<OrdersProvider>(context).fetchOrderByUsername().then((_) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _isLoading ? Center(child: CircularProgressIndicator(),) : OrderListView());
  }
}
