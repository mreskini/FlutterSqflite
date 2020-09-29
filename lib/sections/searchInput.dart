import 'package:flutter/material.dart';
import 'package:search/shared/functions.dart';

class SearchInput extends StatefulWidget {
  Function setInputString = null;
  SearchInput({this.setInputString});
  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        child: Form(
          key: this._formKey,
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 10,
                right: 0,
                top: 0,
                bottom: 0,
              ),
              hintText: "Search for Food...",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Functions().getColorFromHex("F4F1F5"),
                width: 1,
              )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Functions().getColorFromHex("F4F1F5"),
                width: 1,
              )),
              hintStyle: TextStyle(
                color: Functions().getColorFromHex("DFDCE0"),
              ),
            ),
            onChanged: (value) => {
              widget.setInputString(value),
            },
          ),
        ),
      ),
    );
  }
}
