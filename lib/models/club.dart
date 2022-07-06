import 'package:json_annotation/json_annotation.dart';

part 'club.g.dart';

@JsonSerializable()
class Club {
  Club({
    required this.id,
    required this.stadiumId,
    required this.clubName,
    required this.img,
    required this.country,
  });

  int id;
  int stadiumId;
  String clubName;
  String img;
  String country;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  Map<String, dynamic> toJson() => _$ClubToJson(this);
}
