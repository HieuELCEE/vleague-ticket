import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  Badge(
    @required this.child,
    @required this.value,
  );

  final Widget child;
  final String value;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          bottom: 18,
          child: Container(
            padding: EdgeInsets.all(1.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color != null
                  ? color
                  : Colors.deepOrange,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white
              ),
            ),
          ),
        )
      ],
    );
  }
}
