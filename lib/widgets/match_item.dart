import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../util/date_util.dart';
import '../models/league_match.dart';
import '../screens/match_detail_screen.dart';

class MatchItem extends StatelessWidget {
  const MatchItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final leagueMatch = Provider.of<LeagueMatch>(context);
    final dateTime = leagueMatch.timeStart;
    String weekday = DateUtil.convertDateToString(dateTime, 'EE').toUpperCase();
    String date = DateUtil.convertDateToString(dateTime, 'dd MMM');
    String year = DateUtil.convertDateToString(dateTime, 'yyyy');
    String time = DateUtil.convertDateToString(dateTime, 'hh:mm aa');
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MatchDetailScreen.routeName, arguments: {
          'leagueId': leagueMatch.id,
        });
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(5),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 70,
                      child: Text(
                        '$weekday',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    Container(
                      child: Text(
                        '$date',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    Container(
                      child: Text(
                        '$year',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    Container(
                      child: Text(
                        '$time',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${leagueMatch.clubHome.clubName}',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'vs',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    '${leagueMatch.clubVisitor.clubName}',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${leagueMatch.stadium.stadiumName}',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
