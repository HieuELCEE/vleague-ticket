// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Area _$AreaFromJson(Map<String, dynamic> json) {
  return Area(
    id: json['id'] as int,
    areaName: json['areaName'] as String,
    stadiumId: json['stadiumId'] as int,
    capacity: json['capacity'] as int,
  );
}

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'id': instance.id,
      'areaName': instance.areaName,
      'stadiumId': instance.stadiumId,
      'capacity': instance.capacity,
    };
