


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDropdown extends StatefulWidget{

  final String currencyValue;
  final Function onChanged;
  final String loadingText;
  final String assetFile;

  MyDropdown(
      {@required this.currencyValue,
        @required this.onChanged,
        @required this.assetFile,
        this.loadingText = "Loading"});

  @override
  _MyDropdown createState() => _MyDropdown();

}

class _MyDropdown extends State<MyDropdown> {
  List<dynamic> myList;
  bool listLoading = true;

  getMyList() async {
    String jsonRes = await rootBundle.loadString(widget.assetFile);
    var res = json.decode(jsonRes);

    setState(() {
      myList = res;
      print(myList);
      print(myList);
      listLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myList = [
      {'cc': widget.loadingText, 'name': widget.loadingText, 'symbol': ''}
    ];
    getMyList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new DropdownButton<String>(
            //isExpanded: false,
            items: myList.map((value) {
              return new DropdownMenuItem<String>(
                value: value['cc'],
                child: Align(
                    child: new Text(value['name'] + " - " + value['symbol'])),
              );
            }).toList(),
            value: listLoading ? widget.loadingText : widget.currencyValue,
            onChanged: (val) {
              setState(() {
                var selected = myList.firstWhere((c) => c['cc'] == val);
                widget.onChanged(val, selected['symbol'] ?? '');
              });
            },
          )
        ],
      ),
    );
  }

}