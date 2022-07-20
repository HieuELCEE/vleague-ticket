import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';

import '../models/order_details.dart';
import '../models/order_details_list.dart';

class OrderDetailProvider with ChangeNotifier {
  List<OrderDetails> _orderDetailList = [];

  List<OrderDetails> get orderDetailList {
    return [..._orderDetailList];
  }

  static List<OrderDetails> parseOrderDetailJson(List<dynamic> responseBody) {
    var parsedJson = OrderDetailsList.fromJson(responseBody);
    return parsedJson.orderDetailsList;
  }

  Future<List<OrderDetails>> fetchOrderDetailByOrderId(int id) async {
    var options = BaseOptions(
      baseUrl: 'http://localhost:8081/api/v1/',
    );

    try {
      Dio dio = Dio(options);
      dio.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: 'http://localhost:8081/api/v1/'))
              .interceptor);
      var response = await dio.get('/orderDetail/orderId/${id}',
          options: buildCacheOptions(
            Duration(days: 3),
            maxStale: Duration(days: 7),
            forceRefresh: true,
          ));
      if (response.statusCode == 200) {
        _orderDetailList = await parseOrderDetailJson(response.data);
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
    return _orderDetailList;
  }

  Future<List<OrderDetails>> forceRefresh(int id) async {
    var options = BaseOptions(
      baseUrl: 'http://localhost:8081/api/v1/',
    );

    try {
      Dio dio = Dio(options);
      dio.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: 'http://localhost:8081/api/v1/'))
              .interceptor);
      var response = await dio.get('/orderDetail/orderId/${id}',
          options: buildCacheOptions(
            Duration(days: 3),
            maxStale: Duration(days: 7),
            forceRefresh: true,
          ));
      print(response.data);
      if (response.statusCode == 200) {
        _orderDetailList = await parseOrderDetailJson(response.data);
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
    return _orderDetailList;
  }
}
