
import 'dart:io';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/login_page.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/loading_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart' as prefix0;

class AddEventScreen extends StatefulWidget {
  User user;

  AddEventScreen({
    Key key,
    this.user,
  });

  @override
  State createState() {
    return _AddEventScreen();
  }
}

class _AddEventScreen extends State<AddEventScreen> {

  @override
  Widget build(BuildContext context) {

    return _handleCurrentSession();
  }

  Widget _handleCurrentSession(){
    //final user = Provider.of<UserRepository>(context);
    //print(user.status);
    print(widget.user.name);
    return Consumer(
      builder: (context, EventModel user, _) {
        return EventScreen();
        /*switch(user.status){

          case Status.Uninitialized:
            return Splash();
            break;
          case Status.Authenticated:
            return
            EventScreen();
            break;
          case Status.Authenticating:
          case Status.Unauthenticated:
            return LoginPage();
            break;
        }*/
      },
    );
  }
}

class EventScreen extends StatefulWidget{

  @override
  State createState() {
    return _EventScreen();
  }
}

class _EventScreen extends State<EventScreen>{

  @override
  Widget build(BuildContext context) {

    return BlanckPage(
      title: FlutterI18n.translate(context, 'acuedd.events.title'),

      body: ListView(
          children: <Widget>[
          Text("fuck")
        ],
      ),
    );
  }
}