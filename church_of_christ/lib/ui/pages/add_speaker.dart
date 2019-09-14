
import 'dart:async';
import 'dart:io';

import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/widgets/card_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:row_collection/row_collection.dart';

class AddSpeaker extends StatefulWidget{
  User user;
  Speaker speakerLoad;
  File image;

  AddSpeaker({
    Key key,
    this.speakerLoad, this.user, this.image
  });

  @override
  State createState() {
    return _AddSpeaker();
  }
}

class _AddSpeaker extends State<AddSpeaker>{
  TextStyle style = TextStyle(fontFamily: 'Lato', fontSize: 15.0);
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext _scaffoldContext;
  final db = DbChurch();

  final _textNameController = TextEditingController();
  final _textBioController = TextEditingController();
  final _textCompanyController = TextEditingController();
  final _textTwitterController = TextEditingController();
  final _textFbController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.speakerLoad != null){
      _textNameController.text = widget.speakerLoad.name;
      _textBioController.text = widget.speakerLoad.bio;
      _textCompanyController.text = widget.speakerLoad.company;
      _textTwitterController.text = widget.speakerLoad.twitter;
      _textFbController.text = widget.speakerLoad.fb;
    }
  }

  Widget _getBodyMyEvent(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'acuedd.speakers.title'),
          style: TextStyle(fontFamily: 'Lato'),
        ),
        centerTitle: false,
        actions: <Widget>[
          //PopupSettins()
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              save(context);
            },
            child: Text(FlutterI18n.translate(context, 'app.save')),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          if(widget.speakerLoad != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                delete();
              },
            ),
        ],
      ),
      body: new Builder(
        builder: (BuildContext context){
          _scaffoldContext = context;
          return Form(
              key: _formKey,
              child: Center(
                child: ListView(
                  children: <Widget>[
                    _getContinerPic(context),
                    Separator.divider(indent: 72),
                    _getContainerName(context),
                    _getContainerBio(context),
                    _getContainerCompany(context),
                    _getContainerTwitter(context),
                    _getContainerFb(context),
                  ]
                )
              )
          );
        },
      ),
    );
  }

  _getContinerPic(BuildContext context){
    return Container(
      alignment: Alignment.center,
      child: CardImageWithFabIcon(
        imageFile: (widget.speakerLoad != null)?widget.speakerLoad.imagePath :widget.image,//"assets/img/sunset.jpeg",
        iconData: Icons.camera_alt,
        width: 350.0,
        height: 250.0,left: 0,
        internet: (widget.speakerLoad != null)?true:false,
      ),
    );
  }

  _getContainerName(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textNameController,
        style: style,
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, 'acuedd.speakers.name'),
          //border: OutlineInputBorder()
        ),
      ),
    );
  }

  _getContainerBio(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textBioController,
        maxLines: 4,
        style: style,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, 'acuedd.speakers.bio'),
          //border: OutlineInputBorder()
        ),
      ),
    );
  }

  _getContainerCompany(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textCompanyController,
        style: style,
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, 'acuedd.speakers.company'),
          //border: OutlineInputBorder()
        ),
      ),
    );
  }

  _getContainerTwitter(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textTwitterController,
        style: style,
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, 'acuedd.speakers.twitter'),
          //border: OutlineInputBorder()
        ),
      ),
    );
  }

  _getContainerFb(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textFbController,
        style: style,
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, 'acuedd.speakers.facebook'),
          //border: OutlineInputBorder()
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.image == null && widget.speakerLoad == null){
      Navigator.pop(context);
    }
    return _getBodyMyEvent(context);
  }

  void save(BuildContext context){
    final FormState form = _formKey.currentState;

    Scaffold
        .of(_scaffoldContext)
        .showSnackBar(SnackBar(content: Text(FlutterI18n.translate(context, 'acuedd.events.processing')),duration: Duration(minutes: 4),));

    print("eventediting");
    print(widget.speakerLoad);
    if(widget.speakerLoad != null){
      db.updateSpeaker(Speaker(
        id: widget.speakerLoad.id,
        name: _textNameController.text,
        bio: _textBioController.text,
        company: _textCompanyController.text,
        twitter: _textTwitterController.text,
        fb: _textFbController.text,
      ));
      print("UPDATE EL SPEAKER");
      Scaffold.of(_scaffoldContext).removeCurrentSnackBar();
      Scaffold
          .of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text(FlutterI18n.translate(context, 'acuedd.speakers.saveData'))));
      const timeOut = const Duration(seconds: 4);
      new Timer(timeOut, (){
        Navigator.pop(_scaffoldContext);
      });
    }
    else{
      String path = "${widget.user.uid}/${DateTime.now().toString()}.jpg";
      db.uploadFile(path, widget.image)
          .then((StorageUploadTask storageUploadTask){
            storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
              snapshot.ref.getDownloadURL().then((urlImage){
                db.addSpeaker(new Speaker(
                    id: null,
                    name: _textNameController.text,
                    bio: _textBioController.text,
                    company: _textCompanyController.text,
                    twitter: _textTwitterController.text,
                    fb: _textFbController.text,
                    imagePath:urlImage,
                ), widget.user).whenComplete((){
                  print("GUARDO EL SPEAKER");
                  Scaffold.of(_scaffoldContext).removeCurrentSnackBar();
                  Scaffold
                      .of(_scaffoldContext)
                      .showSnackBar(
                      SnackBar(
                        content: Text(FlutterI18n.translate(context, 'acuedd.speakers.saveData')),
                      )
                  );
                  const timeOut = const Duration(seconds: 4);
                  new Timer(timeOut, (){
                    Navigator.pop(_scaffoldContext);
                  });
                });
              });
            })
            .catchError((error){
              print("ERROR WHEN UPLOAD FILE SPEAKER\n");
              print(error);
            });
      });
    }

  }

  void delete(){

    db.deleteSpeaker(widget.speakerLoad);
    Navigator.pop(_scaffoldContext);
  }
}
