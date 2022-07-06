import 'package:json_annotation/json_annotation.dart';

part 'stadium.g.dart';

@JsonSerializable()
class Stadium {
  Stadium({
    required this.id,
    required this.stadiumName,
    required this.location,
    required this.capacity,
    required this.img,
  });

  int id;
  String stadiumName;
  String location;
  String capacity;
  String img;

  factory Stadium.fromJson(Map<String, dynamic> json) => _$StadiumFromJson(json);
  Map<String, dynamic> toJson() => _$StadiumToJson(this);
}
