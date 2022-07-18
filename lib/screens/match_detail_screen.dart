import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vleague_ticket_v2/models/club.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/cart.dart';
import '../providers/tickets_provider.dart';
import '../providers/matches_provider.dart';
import '../providers/page.dart';
import '../widgets/ticket_item.dart';
import '../screens/cart_screen.dart';
import '../screens/tabs_screen.dart';
import '../util/date_util.dart';

class MatchDetailScreen extends StatefulWidget {
  static const routeName = '/match_detail_screen';
  const MatchDetailScreen({Key? key}) : super(key: key);

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  var _expandable1 = false;
  var _expandable2 = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final matchId = arguments['leagueId'];
      Provider.of<TicketsProvider>(context).fetchTickets(matchId).then((_) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = Provider.of<Cart>(context).itemCount;
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final leagueMatchId = arguments['leagueId'];
    final leagueMatch = Provider.of<MatchesProvider>(context, listen: false)
        .findMatchById(leagueMatchId);
    final page = Provider.of<PageProvider>(context);
    final homeTeam = leagueMatch.clubHome;
    final guestTeam = leagueMatch.clubVisitor;
    final stadium = leagueMatch.stadium;
    final dateTime = leagueMatch.timeStart;
    final dayOfMatch = DateUtil.convertDateToString(dateTime, 'EE');
    final dateOfMatch = DateUtil.convertDateToString(dateTime, 'dd MMM');
    final time = DateUtil.convertDateToString(dateTime, 'hh:mm aa');
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Detail'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClubComponent(team: homeTeam),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        '$dayOfMatch, $dateOfMatch',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '$time',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                  flex: 2,
                ),
                ClubComponent(team: guestTeam),
              ],
            ),
            Divider(
              thickness: 1,
              height: 50,
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Stadium',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    subtitle: Text('${stadium.stadiumName}'),
                    trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _expandable1 = !_expandable1;
                          });
                        },
                        icon: Icon(_expandable1
                            ? Icons.expand_less
                            : Icons.expand_more)),
                  ),
                  if (_expandable1)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      height: min(5 * 20.0 + 10.0, 150.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                  child: Container(
                                      child: Text(
                                'Địa chỉ: ${stadium.location}',
                                style: TextStyle(color: Colors.grey),
                              ))),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Sức chứa: ${stadium.capacity} chỗ',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                ],
              ),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Ticket',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Choose your ticket'),
                    trailing: _isLoading
                        ? Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                _expandable2 = !_expandable2;
                              });
                            },
                            icon: Icon(_expandable2
                                ? Icons.expand_less
                                : Icons.expand_more),
                          ),
                  ),
                  if (_expandable2)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      height: min(5 * 30.0 + 10.0, 150.0),
                      child: Consumer<TicketsProvider>(
                        builder: (ctx, ticketsProvider, child) => Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) =>
                                ChangeNotifierProvider.value(
                              value: ticketsProvider.tickets[index],
                              child: TicketItem(),
                            ),
                            itemCount: ticketsProvider.tickets.length,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            Flexible(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: itemCount == 0
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.blue)),
                                onPressed: () {},
                                child: Text(
                                  'GO TO YOUR CART',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  page.currPage = 1;
                                  Navigator.of(context)
                                      .popAndPushNamed(TabsScreen.routeName, arguments: {'cartPage': 1});
                                },
                                child: Text('GO TO YOUR CART', style: TextStyle(fontWeight: FontWeight.bold),))),
                    Text(
                      'Items on Cart: ${itemCount}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClubComponent extends StatelessWidget {
  const ClubComponent({
    Key? key,
    required this.team,
  }) : super(key: key);

  final Club team;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCachedNetworkImage(),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              '${team.clubName}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
        ],
      ),
      flex: 2,
    );
  }

  CachedNetworkImage buildCachedNetworkImage() {
    return CachedNetworkImage(
      imageUrl: '${team.img}',
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: 40,
        backgroundImage: imageProvider,
      ),
    );
  }
}
