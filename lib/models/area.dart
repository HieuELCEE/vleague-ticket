import 'package:json_annotation/json_annotation.dart';


part 'area.g.dart';

@JsonSerializable(explicitToJson: true)
class Area {
  int id;
  String areaName;
  int stadiumId;
  int capacity;


  Area({
    required this.id,
    required this.areaName,
    required this.stadiumId,
    required this.capacity,
  });

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);
}
