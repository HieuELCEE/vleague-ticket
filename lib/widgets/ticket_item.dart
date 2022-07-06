import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ticket.dart';
import '../providers/cart.dart';

class TicketItem extends StatelessWidget {
  const TicketItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticket = Provider.of<Ticket>(context);
    final cart = Provider.of<Cart>(context);
    return ListTile(
      title: Text(
        'Area-${ticket.area.areaName}',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      subtitle: Text(
        'Price: \$${ticket.price}',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          cart.addItem(
              ticket.id.toString(), ticket.price, ticket.area.areaName);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added To Your Cart'),
              action: SnackBarAction(
                  label: 'Undo',
                  textColor: Colors.white,
                  onPressed: () {
                    cart.removeSingleItem(ticket.id.toString());
                  }),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Text('Buy Now'),
      ),
    );
  }
}
