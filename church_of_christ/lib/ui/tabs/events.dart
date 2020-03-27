

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/custom_tab.dart';
import 'package:church_of_christ/ui/widgets/intro_page_item.dart';
import 'package:church_of_christ/ui/widgets/page_transformer.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/search.dart';
import 'package:church_of_christ/ui/widgets/search_result.dart';
import 'package:church_of_christ/ui/widgets/sliver_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  User userLogged;
  var db = DbChurch();
  BuildContext _scaffoldContext;

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;
    final user = Provider.of<UserRepository>(context);
    if(user.status == Status.Authenticated){
      setState(() {
        userLogged = User(
          uid: user.user.uid,
          name: user.user.displayName,
          email: user.user.email,
          photoURL: user.user.photoUrl,
          //birthday:
        );
      });
    }
    else {
      userLogged = null;
    }

    return _getScaffoldBlanckPage(context, userLogged);
  }

  Widget _getScaffoldBlanckPage(BuildContext context, user){
    return Scaffold(
      body: SafeArea(child:
        Container(
          //color: Colors.grey[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: SearchWidget(
                    textHint: "Buscar eventos",
                    onSubmited: (query){
                      Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context){
                          return SearchView(query);
                        }),
                      );
                    },
                  ),
                ),
                //_getFiltersDate(),
                Expanded(
                  child: _buildFeatureds(user),
                ),

              ],
            )
        ),
      )
    );
  }

  Widget _buildFeatureds(user){
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
            if(difference < 24){ //1 day, 24 hour
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
                        category: "Comming soon", myUser: user, scaffoldContext: _scaffoldContext,);
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