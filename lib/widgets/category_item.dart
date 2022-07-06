import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../screens/matches_screen.dart';
import '../../palette.dart';

class CategoryItem extends StatelessWidget {
  final int id;
  final String title;
  final String imgUrl;

  const CategoryItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imgUrl,
  }) : super(key: key);

  void _selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(MatchesScreen.routeName, arguments: {
      'id': id,
      'title': title,
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectCategory(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  // child: Image.network(
                  //   imgUrl,
                  //   height: 250,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  // ),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black12,
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                    placeholder: (context, url) => Container(color: Colors.black12),
                    imageBuilder: (context, imageProvider) => Image(
                      image: imageProvider,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Matches'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.group),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Teams'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.credit_card_sharp),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Ticket'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
