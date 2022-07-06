// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeagueMatch _$LeagueMatchFromJson(Map<String, dynamic> json) => LeagueMatch(
      id: json['id'] as int,
      roundId: json['roundId'] as int,
      stadiumId: json['stadiumId'] as int,
      stadium: Stadium.fromJson(json['stadium'] as Map<String, dynamic>),
      clubHomeId: json['clubHomeId'] as int,
      clubHome: Club.fromJson(json['clubHome'] as Map<String, dynamic>),
      clubVisitorId: json['clubVisitorId'] as int,
      clubVisitor: Club.fromJson(json['clubVisitor'] as Map<String, dynamic>),
      timeStart: DateTime.parse(json['timeStart'] as String),
      status: json['status'] as bool,
    );

Map<String, dynamic> _$LeagueMatchToJson(LeagueMatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roundId': instance.roundId,
      'stadiumId': instance.stadiumId,
      'stadium': instance.stadium.toJson(),
      'clubHomeId': instance.clubHomeId,
      'clubHome': instance.clubHome.toJson(),
      'clubVisitorId': instance.clubVisitorId,
      'clubVisitor': instance.clubVisitor.toJson(),
      'status': instance.status,
      'timeStart': instance.timeStart.toIso8601String(),
    };
