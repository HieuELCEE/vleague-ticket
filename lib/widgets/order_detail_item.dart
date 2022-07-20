import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_details.dart';

class OrderDetailItem extends StatelessWidget {
  final String areaName;
  final int quantity;
  final double price;
  const OrderDetailItem({Key? key, required this.areaName, required this.quantity, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        title: Text('Ticket Area-${areaName}',
          style: TextStyle(
            color: Colors.blue,
          ),),
        subtitle: Text('Total: \$${quantity * price}'),
        trailing: Text('Qty: ${quantity}'),
      ),
    );
  }
}
