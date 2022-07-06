import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vleague_ticket_v2/models/league_match.dart';

import '../providers/matches_provider.dart';
import '../widgets/match_item.dart';
import '../widgets/searchbar.dart';

class MatchesListView extends StatefulWidget {
  MatchesListView({Key? key}) : super(key: key);

  @override
  State<MatchesListView> createState() => _MatchesListViewState();
}

class _MatchesListViewState extends State<MatchesListView> {
  final _controller = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    _controller.addListener(
          () {
        setState(() {
          _searchText = _controller.text;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeString(String search) {
    Provider.of<MatchesProvider>(context, listen: false).changeSearchString(search);
  }

  Future<void> _refreshMatches(BuildContext context) async {
    await Provider.of<MatchesProvider>(context, listen: false).forceRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.grey);
    final style = _searchText.isEmpty ? styleHint : styleActive;
    final matchesProvider = Provider.of<MatchesProvider>(context);
    var matches = matchesProvider.matches;
    return Scaffold(
      appBar: AppBar(
        title: Text('V.league 1'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshMatches(context),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 42,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: Colors.black26),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _searchText.isNotEmpty
                      ? GestureDetector(
                    child: Icon(Icons.close, color: style.color),
                    onTap: () {
                      _controller.clear();
                      changeString('');
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  )
                      : null,
                  hintText: 'Club Name',
                  hintStyle: style,
                  border: InputBorder.none,
                ),
                style: style,
                onChanged: (value) {
                  changeString(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: matches[index],
                  child: MatchItem(),
                ),
                itemCount: matches.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
  


}
