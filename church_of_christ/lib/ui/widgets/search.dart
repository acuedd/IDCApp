

import 'package:church_of_christ/ui/widgets/search_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SearchWidget extends StatelessWidget{

  String textHint = 'app.search';
  final TextEditingController editingController = new TextEditingController();
  BuildContext _context;

  SearchWidget({
    Key key,
    @required this.textHint
  });

  @override
  Widget build(BuildContext context) {
    _context = context;

    return new Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      margin: const EdgeInsets.only(),
      child: new Material(
        borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
        elevation: 2.0,
        child: new Container(
          height: 45.0,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    maxLines: 1,
                    decoration: new InputDecoration(
                      icon: Icon(Icons.search, color: Theme.of(context).accentColor,),
                      hintText: FlutterI18n.translate(context, ''),
                      border: InputBorder.none,
                    ),
                    onSubmitted: onSubmitted,
                    controller: editingController,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  onSubmitted(query){
    Navigator.of(_context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return SearchView(query);
      }
    ));
  }
}