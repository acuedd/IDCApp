
import 'dart:io';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/login_page.dart';
import 'package:church_of_christ/ui/widgets/card_image.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/loading_splash.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart' as prefix0;
import 'package:row_collection/row_collection.dart';

class AddEventScreen extends StatefulWidget {
  User user;
  File image;

  AddEventScreen({
    Key key,
    this.user,
    this.image,
  });

  @override
  State createState() {
    return _AddEventScreen();
  }
}

class _AddEventScreen extends State<AddEventScreen> {

  TextStyle style = TextStyle(fontFamily: 'Lato', fontSize: 12.0);

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Widget _getBodyMyEvent(){
    return BlanckPage(
        title: FlutterI18n.translate(context, 'acuedd.events.add.subtitle'),
        actions: <Widget>[
          PopupSettins()
        ],
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: CardImageWithFabIcon(
                    imageFile: widget.image,//"assets/img/sunset.jpeg",
                    iconData: Icons.camera_alt,
                    width: 350.0,
                    height: 250.0,left: 0,
                    internet: false,
                  ),
                ), //Foto
                Separator.divider(indent: 72),
                HeaderText(text: "Basicos"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    style: style,
                    decoration: InputDecoration(
                      hintText: "Nombre del evento",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    maxLines: 4,
                    style: style,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Descripcion",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    maxLines: 1,
                    style: style,
                    decoration: InputDecoration(
                      hintText: "Dirección",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),
                Separator.divider(indent: 72),
                HeaderText(text: "Entradas"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: style,
                    decoration: InputDecoration(
                      hintText: "Coto de entradas",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),
                HeaderText(text: "Networking"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    maxLines: 1,
                    style: style,
                    decoration: InputDecoration(
                      hintText: "Url de video",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    maxLines: 1,
                    style: style,
                    decoration: InputDecoration(
                      hintText: "Url facebook",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    maxLines: 1,
                    style: style,
                    decoration: InputDecoration(
                      hintText: "Url twiter",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),
              ])
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getBodyMyEvent();
  }
}
