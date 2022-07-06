import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import './club.dart';
import './stadium.dart';

part 'league_match.g.dart';

@JsonSerializable(explicitToJson: true)
class LeagueMatch with ChangeNotifier{
  LeagueMatch({
    required this.id,
    required this.roundId,
    required this.stadiumId,
    required this.stadium,
    required this.clubHomeId,
    required this.clubHome,
    required this.clubVisitorId,
    required this.clubVisitor,
    required this.timeStart,
    required this.status,
  });

  int id;
  int roundId;
  int stadiumId;
  Stadium stadium;
  int clubHomeId;
  Club clubHome;
  int clubVisitorId;
  Club clubVisitor;
  bool status;
  DateTime timeStart;

  factory LeagueMatch.fromJson(Map<String, dynamic> json) => _$LeagueMatchFromJson(json);

  Map<String, dynamic> toJson() => _$LeagueMatchToJson(this);
}