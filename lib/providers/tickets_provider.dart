import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../models/tickets_list.dart';
import '../models/ticket.dart';

class TicketsProvider with ChangeNotifier {
  List<Ticket> _tickets = [];

  List<Ticket> get tickets {
    return [..._tickets];
  }

  static List<Ticket> parseAreasJson(List<dynamic> responseBody) {
    var parsedJson = TicketList.fromJson(responseBody);
    return parsedJson.tickets;
  }

  Future<List<Ticket>> fetchTickets(int matchId) async {
    try {
      // final url =
      //     Uri.parse('http://localhost:8081/api/v1/ticket/matchId/$matchId');
      // final response = await http.get(url);
      // if (response.statusCode == 200) {
      //   print(response.body);
      //   _tickets = await compute(parseAreasJson, response.body);
      //   notifyListeners();
      // } else {
      //   print('An error occurred');
      // }
      var options = BaseOptions(
        baseUrl: 'http://localhost:8081/api/v1/',
      );
      Dio dio = Dio(options);
      dio.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: 'http://localhost:8081/api/v1/'))
              .interceptor);
      var dioResponse = await dio.get(
        '/ticket/matchId/${matchId}',
        options: buildCacheOptions(
          Duration(minutes: 30),
          maxStale: Duration(minutes: 30),
          forceRefresh: true,
        ),
      );
      if (dioResponse.statusCode == 200) {
        print(dioResponse.data);
        _tickets = await parseAreasJson(dioResponse.data);
        notifyListeners();
      } else {
        print('Error occurred');
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
    return _tickets;
  }
}
