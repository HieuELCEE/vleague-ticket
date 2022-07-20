import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order.dart';
import '../models/orders_list.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  static List<Order> parseOrdersJson(List<dynamic> resonseBody) {
    var parsedJson = OrderList.fromJson(resonseBody);
    return parsedJson.orders;
  }

  Future<List<Order>> fetchOrderByUsername() async {
    var username = FirebaseAuth.instance.currentUser!.email;
    var options = BaseOptions(
      baseUrl: 'http://localhost:8081/api/v1/',
    );

    try {
      print(username);
      Dio dio = Dio(options);
      dio.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: 'http://localhost:8081/api/v1/'))
              .interceptor);
      var response = await dio.get('/order/username/$username',
          options: buildCacheOptions(
            Duration(days: 3),
            maxStale: Duration(days: 7),
            forceRefresh: true,
          ));
      if (response.statusCode == 200) {
        _orders = parseOrdersJson(response.data).reversed.toList();
        notifyListeners();
      } else {
        print("An error occurred");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print("ERROR RESPONSE + ${e.response!.data}");
        print("ERROR HEADER + ${e.response!.headers}");
        print("ERROR OPTIONS + ${e.response!.requestOptions}");
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    }
    return _orders;
  }

  Future<void> forceRefresh() async {
    var username = FirebaseAuth.instance.currentUser!.email;
    var options = BaseOptions(
      baseUrl: 'http://localhost:8081/api/v1/',
    );

    try {
      Dio dio = Dio(options);
      dio.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: 'http://localhost:8081/api/v1/'))
              .interceptor);
      var response = await dio.get('/order/username/$username',
          options: buildCacheOptions(
            Duration(days: 3),
            maxStale: Duration(days: 7),
            forceRefresh: true,
          ));
      print(response.data);
      if (response.statusCode == 200) {
        _orders = await parseOrdersJson(response.data).reversed.toList();
        notifyListeners();
      } else {
        print("An error occurred");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print("ERROR RESPONSE + ${e.response!.data}");
        print("ERROR HEADER + ${e.response!.headers}");
        print("ERROR OPTIONS + ${e.response!.requestOptions}");
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    }
  }
}
