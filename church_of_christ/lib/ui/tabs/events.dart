

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/custom_tab.dart';
import 'package:church_of_christ/ui/widgets/intro_page_item.dart';
import 'package:church_of_christ/ui/widgets/page_transformer.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/search.dart';
import 'package:church_of_christ/ui/widgets/sliver_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class EventsScreen extends StatefulWidget{

  const EventsScreen({
    Key key,
  }) : super(key:key);

  @override
  State createState() {
    return _EventsScreen();
  }
}

class _EventsScreen extends State<EventsScreen>{
  var db = DbChurch();

  @override
  Widget build(BuildContext context) {
    return _getScaffoldBlanckPage(context);
  }

  Widget _getScaffoldBlanckPage(BuildContext context){
    return Scaffold(
      body: SafeArea(child:
        Container(
          //color: Colors.grey[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: SearchWidget(),
                ),
                //_getFiltersDate(),
                Expanded(
                  child: _buildFeatureds(),
                ),

              ],
            )
        ),
      )
    );
  }

  Widget _getFiltersDate(){
    List<String> list = [
      FlutterI18n.translate(context, 'acuedd.events.search.comingsoon'),
      FlutterI18n.translate(context, 'acuedd.events.search.now'),
      FlutterI18n.translate(context, 'acuedd.events.search.previously'),
      FlutterI18n.translate(context, 'acuedd.events.search.memories'),
    ];
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 300),
      child: CustomTab(
        itens: list,
        tabSelected: (index){
          //TODO HERE PUT SENT TO FILTER CATEGORY
        },
      ),
    );
  }

  Widget _buildFeatureds(){
    return StreamBuilder(
      stream: db.streamEventsCommingSoon(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData) {
          var eventsListSnapshot = snapshot.data.documents;
          List _destaque = [];
          eventsListSnapshot.forEach((p) {
            EventModel event = EventModel.fromFirestore(p);
            final dateNow = DateTime.now();
            final difference = dateNow.difference(event.dateTime).inHours;
            if(difference < 0){
              _destaque.add(event);
            }
          });
          var length = snapshot.hasData ? _destaque.length : 0;

          Widget fearured = PageTransformer(
              pageViewBuilder: (context, visibilityResolver) {
                return new PageView.builder(
                    controller: new PageController(viewportFraction: 0.9),
                    itemCount: length,
                    itemBuilder: (context, index) {
                      final pageVisibility =
                      visibilityResolver.resolvePageVisibility(index);
                      return new IntroNewsItem(item: _destaque[index],
                        pageVisibility: pageVisibility,
                        category: "Comming soon",);
                    }
                );
              });

          return AnimatedOpacity(
            opacity: length > 0 ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: fearured,
          );
        }
        return Container(child: Center(child: CircularProgressIndicator(),),);
      },
    );
  }
}