import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:search/sections/details.dart';
import 'package:search/sections/header.dart';
import 'package:search/sections/itemClass.dart';
import 'package:search/sections/searchInput.dart';
import 'package:search/shared/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  runApp(MaterialApp(
    routes: {
      "/details": (context) => Details(),
    },
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  bool spinner = true;
  String inputText = "";
  int ratio = 0;
  List<Item> matchedItems = [];
  List<Item> items = [];
  String dbPath = "gorcis4.db";
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Database> database;
  void connectToDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      join(await getDatabasesPath(), widget.dbPath),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT , score REAL , energy REAL , su REAL , amountOfGram INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertItem(Item item) async {
    final Database db = await database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> items() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    List<Item> items = List.generate(
      maps.length,
      (i) {
        return Item(
          title: maps[i]['title'],
          score: maps[i]['score'],
          energy: maps[i]['energy'],
          su: maps[i]['su'],
          amountOfGram: maps[i]['amountOfGram'],
        );
      },
    );
    return items;
  }

  void _setInputString(String str) {
    setState(() {
      widget.inputText = str;
    });
  }

  void getItemListFromApi() async {
    if (!await databaseExists(widget.dbPath)) {
      connectToDB();
      print("getting data from api...");
      Response response = await get(
          "http://gorcis.com/api/cache/edibles.php?ut=43f31b20-2ee8-4272-bda0-44d43118e6b3");
      dynamic data = jsonDecode(response.body);
      int size = data.length;
      for (int i = 0; i < size; i += 1) {
        Item newItem = Item(
          title: data[i]["name"],
          score: data[i]['pointsPerSmallestSteps'][0] * 1.0,
          energy: data[i]['nutritionalData'][0]["Enerji"]["value"] * 1.0,
          amountOfGram: 100,
        );
        print(newItem);
        await insertItem(newItem);
        if (i % 100 == 0) {
          setState(() {
            widget.ratio = ((i / size) * 100.0).round();
          });
        }
      }

      setState(() {
        widget.spinner = false;
      });

      print("data has been fetched");
    }
    await connectToDB();
    List<Item> maps = await items();
    maps.forEach((element) {
      widget.items.add(element);
    });
    print("Reading data from LocalDatabase");
    setState(() {
      widget.spinner = false;
    });
    print("Data has been fetched");
  }

  @override
  void initState() {
    super.initState();
    getItemListFromApi();
  }

  @override
  Widget build(BuildContext context) {
    widget.matchedItems = [];
    widget.items.forEach((element) {
      if (widget.inputText.length >= 2 &&
          element.title.startsWith(widget.inputText)) {
        widget.matchedItems.add(element);
      }
    });

    if (widget.spinner == true) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitFoldingCube(
                color: Colors.grey,
                size: 50.0,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                widget.ratio.toString() + " %",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: true,
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Header(),
              SearchInput(
                setInputString: _setInputString,
              ),
              Expanded(
                flex: 11,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/details", arguments: {
                            "title": widget.matchedItems[index].title,
                            "energy": widget.matchedItems[index].energy,
                          });
                        },
                        padding: EdgeInsets.all(0),
                        child: Container(
                          padding: EdgeInsets.only(
                            right: 10,
                            left: 10,
                            top: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Row(children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.matchedItems[index].title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.matchedItems[index].amountOfGram
                                            .toString() +
                                        " gram",
                                    style: TextStyle(
                                      color:
                                          Functions().getColorFromHex("3E3B3F"),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          Functions().getColorFromHex("F7244F"),
                                      child: Text(
                                        (widget.matchedItems[index].score *
                                                100.0)
                                            .round()
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                    itemCount: widget.matchedItems.length),
              )
            ],
          ),
        ),
      );
    }
  }
}
