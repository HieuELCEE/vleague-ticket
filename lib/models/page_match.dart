import 'package:json_annotation/json_annotation.dart';
import './league_match.dart';

part 'page_match.g.dart';

@JsonSerializable(explicitToJson: true)
class PageMatch {
  PageMatch({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.matches,
  });

  int totalItems;
  int totalPages;
  int currentPage;
  List<LeagueMatch> matches;

  factory PageMatch.fromJson(Map<String, dynamic> json) => _$PageMatchFromJson(json);

  Map<String, dynamic> toJson() => _$PageMatchToJson(this);
}
