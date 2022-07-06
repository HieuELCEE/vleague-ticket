// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageMatch _$PageMatchFromJson(Map<String, dynamic> json) => PageMatch(
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int,
      matches: (json['matches'] as List<dynamic>)
          .map((e) => LeagueMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PageMatchToJson(PageMatch instance) => <String, dynamic>{
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'matches': instance.matches.map((e) => e.toJson()).toList(),
    };
