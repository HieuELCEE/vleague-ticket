import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vleague_ticket_v2/models/cart_info_list.dart';

import '../providers/cart.dart';
import '../models/cart_info.dart';
import '../models/invoice.dart';

class InvoiceProvider with ChangeNotifier {
  List<CartInfo> getCartInfo(Cart cart) {
    List<CartInfo> listCartInfo = [];
    cart.items.forEach((key, value) {
      listCartInfo.add(new CartInfo(
        quantity: value.quantity,
        ticketId: int.parse(key),
      ));
    });
    return listCartInfo;
  }

  Future<void> addInvoice(List<CartInfo> cartInfo, double amount) async {
    var username = FirebaseAuth.instance.currentUser!.email;
    var url = Uri.parse('http://localhost:8081/api/v1/order');
    print("TYPE OF DATA " + jsonEncode(cartInfo).toString());
    var requestBody = jsonEncode({
      "cartLines": cartInfo,
      "orderDate": DateTime.now().toString(),
      "total": amount,
      "userName": '$username',
    });
    var response = await http.post(
      url,
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: requestBody,
    );
    if (response.statusCode == 200) {
      print('SUCCESS');
    } else {
      print('ERROR');
    }
  }
}
