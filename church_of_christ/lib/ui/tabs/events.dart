

import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/search.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlanckPage(
      title: FlutterI18n.translate(context, 'acuedd.events.title'),
      actions: <Widget>[
        PopupSettins()
      ],
      body: Container(
        //color: Colors.grey[200],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: SearchWidget(),
            ),

          ],
        )
      ),
    );
  }
}