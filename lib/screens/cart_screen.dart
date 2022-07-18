import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//PROVIDER
import '../providers/cart.dart';
import '../providers/momo_service.dart';
import '../providers/resultcode.dart';
import '../providers/notification_service.dart';

//WIDGET
import '../widgets/cart_item.dart';
import '../screens/payment_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart_screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _total;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async{
       _total = Provider.of<Cart>(context, listen: false).total;
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);
    final momo = Provider.of<MomoService>(context);
    final notification = Provider.of<NotificationService>(context, listen: false);
    bool isEmpty = cart.itemCount == 0;
    return isEmpty
        ? Center(
            child: Text('No item in your cart'),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, index) {
                    return CartItemWidget(
                      id: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                      title: cart.items.values.toList()[index].title,
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity,
                    );
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.all(15),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      if (cart.items.length != 0)
                        Chip(
                          label: Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        )
                      else
                        Chip(
                          label: Text(
                            '\$${cart.totalAmount}',
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.white,
                          shape: StadiumBorder(side: BorderSide()),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              OrderButton(cart: cart, momo: momo, info: 'Ticket'),
              SizedBox(
                height: 10,
              ),
            ],
          );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
    required this.momo,
    required this.info,
  }) : super(key: key);

  final MomoService momo;
  final Cart cart;
  final String info;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final code = Provider.of<ResultCode>(context, listen: true);
    return ElevatedButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              int statusCode = await widget.momo
                  .createRequest(widget.cart.totalAmount.toInt(), widget.info);
              setState(() {
                _isLoading = false;
              });

              if (statusCode == 200) {
                var momoUrl = widget.momo.launchUrl;
                Navigator.of(context).pushNamed(PaymentScreen.routeName);
              }
            },
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text('CHECK OUT'),
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
    );
  }
}
