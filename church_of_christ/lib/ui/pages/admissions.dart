
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
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
  final _formKey = GlobalKey<FormState>();
  BuildContext _scaffoldContext;

  final _textNameController = TextEditingController();
  final _textChuchController = TextEditingController();
  final _textPriceController = TextEditingController();

  final db = DbChurch();

  @override
  void initState() {
    super.initState();
    //_textTitleController.text = widget.eventEditing.title;
    _textPriceController.text = widget.eventModel.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, 'acuedd.events.admissions' )),
          centerTitle: false,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                save(context);
              },
              child: Text(FlutterI18n.translate(context, 'app.save')),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: new Builder(
          builder: (BuildContext context) {
            _scaffoldContext = context;
            return Form(
              key: _formKey,
              child:Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _textNameController,
                            style: style,
                            decoration: InputDecoration(
                              labelText: FlutterI18n.translate(context, 'acuedd.events.name'),
                              //border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _textChuchController,
                            style: style,
                            decoration: InputDecoration(
                              labelText: FlutterI18n.translate(context, 'acuedd.events.church'),
                              //border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _textPriceController,
                            style: style,
                            readOnly: true,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: "${FlutterI18n.translate(context, 'acuedd.events.contribution')} - ${widget.eventModel.currency}",
                              //border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ])
              ),
            );
          })
    );
  }

  void save(BuildContext context){
    final FormState form = _formKey.currentState;

    if(form.validate()){
      form.save();

      Scaffold
          .of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text(FlutterI18n.translate(context, 'acuedd.events.processing')),duration: Duration(minutes: 4),));

      RegisterEvent registerEvent = RegisterEvent(
          name: _textNameController.text,
          church: _textChuchController.text,
          currency: widget.eventModel.currency,
          price: double.parse(_textPriceController.text),
          eventid: widget.eventModel.id,
          userid: widget.userLogged.uid,
          nameUserReg: widget.userLogged.name
      );

      db.addAdmission(registerEvent).whenComplete((){
        print("GUARDO LA ADMISION");
        Scaffold.of(_scaffoldContext).removeCurrentSnackBar();
        Scaffold
            .of(_scaffoldContext)
            .showSnackBar(
            SnackBar(
              content: Text(FlutterI18n.translate(context, 'acuedd.events.saveData')),
            )
        );
        Navigator.pop(_scaffoldContext);
      });

    }
  }
}