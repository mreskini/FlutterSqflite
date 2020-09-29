import 'package:flutter/material.dart';
import 'package:search/shared/functions.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 1.0,
            ),
          ],
          color: Functions().getColorFromHex("FAF8FB"),
        ),
        margin: EdgeInsets.all(0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: Functions().getColorFromHex("569AE1"),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      "home",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Functions().getColorFromHex("569AE1"),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Search",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      size: 18,
                      color: Functions().getColorFromHex("569AE1"),
                    ),
                    Text(
                      "My Food",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Functions().getColorFromHex("569AE1"),
                        fontSize: 16,
                      ),
                    ),
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
