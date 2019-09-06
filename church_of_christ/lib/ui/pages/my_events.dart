


import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/login_page.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/loading_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

class MyEvents extends StatefulWidget {
  User user;

  MyEvents({
    Key key,
    this.user,
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
              MyEventScreen();
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

  @override
  State createState() {
    return _MyEventScreen();
  }
}

class _MyEventScreen extends State<MyEventScreen>{

  Widget _getBodyMyEvent(){
    return Consumer<EventModel>(
      builder: (context, model, child) => Scaffold(
        body:
        SliverPage<EventModel>.slide(
          title: FlutterI18n.translate(context, 'acuedd.events.add.title'),
          slides: model.photos,
          body: <Widget>[
            Text("Holiii")
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          child: Icon(Icons.add),
          tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.search'),
          onPressed: (){

          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      builder: (context) => EventModel(),
      child: _getBodyMyEvent(),
    );
  }
}