// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Club _$ClubFromJson(Map<String, dynamic> json) => Club(
      id: json['id'] as int,
      stadiumId: json['stadiumId'] as int,
      clubName: json['clubName'] as String,
      img: json['img'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$ClubToJson(Club instance) => <String, dynamic>{
      'id': instance.id,
      'stadiumId': instance.stadiumId,
      'clubName': instance.clubName,
      'img': instance.img,
      'country': instance.country,
    };
