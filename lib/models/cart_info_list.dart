import '../models/cart_info.dart';


class CartInfoList {
  List<CartInfo> cartInfoList;


  CartInfoList({required this.cartInfoList});

  Map<String, dynamic> toJson() => <String, dynamic> {
    'cartLines' : cartInfoList.map((e) => e.toJson()).toList(),
  };



}