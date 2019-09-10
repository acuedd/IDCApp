


import 'dart:io';

import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/add_event.dart';
import 'package:church_of_christ/ui/pages/login_page.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/loading_splash.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:church_of_christ/data/models/user.dart';

class MyEvents extends StatefulWidget {

  MyEvents({
    Key key,
  });

  @override
  State createState() {
    return _MyEvents();
  }
}

class _MyEvents extends State<MyEvents> {

  @override
  Widget build(BuildContext context) {

    return _handleCurrentSession();
  }

  Widget _handleCurrentSession(){
    return Consumer(
      builder: (context, UserRepository user, _) {
        switch(user.status){

          case Status.Uninitialized:
            return Splash();
            break;
          case Status.Authenticated:
            return
              MyEventScreen(uid:user.user.uid);
            break;
          case Status.Authenticating:
          case Status.Unauthenticated:
            return LoginPage();
            break;
        }
      },
    );
  }
}


class MyEventScreen extends StatefulWidget{

  final String uid;

  MyEventScreen({
    this.uid
  });

  @override
  State createState() {
    return _MyEventScreen();
  }
}

class _MyEventScreen extends State<MyEventScreen>{

  Widget _getBodyBlanckPage(){
    var dbUser = DbChurch();

    return Consumer<EventModelProvider>(
        builder: (context, model, child) => Scaffold(
          body: BlanckPage(
            title: FlutterI18n.translate(context, 'acuedd.events.add.subtitle'),
            actions: <Widget>[
              PopupSettins()
            ],
            body: ListView(
              children: <Widget>[
                Text("Holiii")
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.add),
            tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.search'),
            onPressed: (){
              dbUser.getUser(widget.uid).then((User user){
                ImagePicker.pickImage(source: ImageSource.gallery).then((File image){
                  Navigator.of(context).push(FadeRoute(AddEventScreen(user: user,image: image)));
                }).catchError((onError) => print(onError));
              });
            },
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      builder: (context) => EventModelProvider(),
      child: _getBodyBlanckPage(),
    );
  }
}