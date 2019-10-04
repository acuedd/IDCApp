
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class AdmissionsWidget extends StatefulWidget{

  final EventModel eventModel;
  final User userLogged;

  AdmissionsWidget({
    Key kye,
    this.eventModel,
    this.userLogged,
  });

  @override
  State createState() {
    return _AdmissionsWidget();
  }
}

class _AdmissionsWidget extends State<AdmissionsWidget>{
  TextStyle style = TextStyle(fontFamily: 'Lato', fontSize: 15.0);

  final _textTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_textTitleController.text = widget.eventEditing.title;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, 'acuedd.events.admissions' )),
        ),
        body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textTitleController,
                style: style,
                decoration: InputDecoration(
                  labelText: FlutterI18n.translate(context, 'acuedd.events.basics.name'),
                  //border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textTitleController,
                style: style,
                decoration: InputDecoration(
                  labelText: FlutterI18n.translate(context, 'acuedd.events.basics.name'),
                  //border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textTitleController,
                style: style,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: FlutterI18n.translate(context, 'acuedd.events.basics.name'),
                  //border: OutlineInputBorder()
                ),
              ),
            ),

          ])
        )
    );
  }




}