// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stadium.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stadium _$StadiumFromJson(Map<String, dynamic> json) {
  return Stadium(
    id: json['id'] as int,
    stadiumName: json['stadiumName'] as String,
    location: json['location'] as String,
    capacity: json['capacity'] as String,
    img: json['img'] as String,
  );
}

Map<String, dynamic> _$StadiumToJson(Stadium instance) => <String, dynamic>{
      'id': instance.id,
      'stadiumName': instance.stadiumName,
      'location': instance.location,
      'capacity': instance.capacity,
      'img': instance.img,
    };
