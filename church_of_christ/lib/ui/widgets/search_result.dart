

import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/ui/search/notice.dart';
import 'package:church_of_christ/ui/widgets/animated_content.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {

  final String query;
  var db = DbChurch();
  BuildContext _context;

  SearchView(this.query);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return BlanckPage(
      title: query,
      body:SafeArea(child:
      Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _getListViewWidget(),
        ])
      ),
      ),
    );
  }

  Widget _getListViewWidget(){
    return Expanded(
      child: StreamBuilder(
        stream: db.streamEvents(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData) {
            var eventsListSnapshot = snapshot.data.documents;
            List _destaque = [];
            List tmpSearchStore = [];

            eventsListSnapshot.forEach((p) {
              EventModel event = EventModel.fromFirestore(p);
              tmpSearchStore.add(event);
            });

            tmpSearchStore.forEach((q){
              String searchValue = query.toLowerCase();
              if(q.title.toString().toLowerCase().contains(searchValue)){
                _destaque.add(q);
              }
            });

            var listView = ListView.builder(
                itemCount: _destaque.length,
                padding: new EdgeInsets.only(top: 5.0),
                itemBuilder: (context, index) {
                  return Notice(_destaque[index]);
                }
            );

            return AnimatedContent(
              show: _destaque.length > 0,
              child: listView,
            );
          }

          return Container(child: Center(child: CircularProgressIndicator(),),);
        }
      ),
    );
  }
}