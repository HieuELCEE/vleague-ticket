import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';

import '../models/page_match.dart';
import '../models/league_match.dart';

class MatchesProvider with ChangeNotifier {
  List<LeagueMatch> _matches = [];
  String _searchString = '';

  UnmodifiableListView<LeagueMatch> get matches => _searchString.isEmpty
      ? UnmodifiableListView(_matches)
      : UnmodifiableListView(_matches.where((match) {
    var homeTeam = match.clubHome.clubName.toLowerCase();
    var guestTeam = match.clubVisitor.clubName.toLowerCase();
    var search = _searchString.toLowerCase();
    return homeTeam.contains(search) || guestTeam.contains(search);
  }));

  void changeSearchString(String searchString) {
    _searchString = searchString;
    print(_searchString);
    notifyListeners();
  }

  List<LeagueMatch> get leagueMatches {
    return [..._matches];
  }

  static List<LeagueMatch> parsePageMatches(Map<String, dynamic> responseBody) {
    final parsedData = PageMatch.fromJson(responseBody);
    return parsedData.matches;
  }

  Future<List<LeagueMatch>> fetchLeagueMatches() async {
    try {
      // final url = Uri.parse('http://localhost:8081/api/v1/match');
      // final response = await http.get(url);
      // if (response.statusCode == 200) {
      //   print(response.body);
      //   _matches = await compute(parsePageMatches, response.body);
      //   notifyListeners();
      // } else {
      //   print('Error occurred');
      // }
      var options = BaseOptions(
        baseUrl: 'http://localhost:8081/api/v1/',
      );
      Dio dio = Dio(options);
      dio.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: 'http://localhost:8081/api/v1/'))
              .interceptor);
      var dioResponse = await dio.get('/match',
          options: buildCacheOptions(
            Duration(minutes: 30),
            maxStale: Duration(minutes: 30),
          ));
      if (dioResponse.statusCode == 200) {
        _matches = await parsePageMatches(dioResponse.data);
        notifyListeners();
      } else {
        print('An error occurred');
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
    return _matches;
  }

  Future<List<LeagueMatch>> forceRefresh() async {
    try {
      // final url = Uri.parse('http://localhost:8081/api/v1/match');
      // final response = await http.get(url);
      // if (response.statusCode == 200) {
      //   print(response.body);
      //   _matches = await compute(parsePageMatches, response.body);
      //   notifyListeners();
      // } else {
      //   print('Error occurred');
      // }
      var options = BaseOptions(
        baseUrl: 'http://localhost:8081/api/v1/',
      );
      Dio dio = Dio(options);
      dio.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: 'http://localhost:8081/api/v1/'))
              .interceptor);
      var dioResponse = await dio.get('/match',
          options: buildCacheOptions(
            Duration(days: 3),
            maxStale: Duration(days: 7),
            forceRefresh: true,
          ));
      if (dioResponse.statusCode == 200) {
        _matches = await parsePageMatches(dioResponse.data);
        notifyListeners();
      } else {
        print('An error occurred');
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
    return _matches;
  }

  LeagueMatch findMatchById(int id) {
    return _matches.firstWhere((match) => match.id == id);
  }

  List<LeagueMatch> searchMatch(String query) {
    _matches =  _matches.where((match) {
      var homeTeam = match.clubHome.clubName.toLowerCase();
      var guestTeam = match.clubVisitor.clubName.toLowerCase();
      var search = query.toLowerCase();
      return homeTeam.contains(search) || guestTeam.contains(search);
    }).toList();
    notifyListeners();
    return _matches;
  }
}
