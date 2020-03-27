

import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/pages/user_info.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';

class AdmissionsDeposit extends StatefulWidget{

  final EventModel eventModel;
  final User userLogged;

  AdmissionsDeposit({
    Key kye,
    this.eventModel,
    this.userLogged,
  });

  @override
  State createState() {
    return _AdmissionDeposit();
  }
}

class _AdmissionDeposit extends State<AdmissionsDeposit>{
  TextStyle style = TextStyle(fontFamily: 'Lato', fontSize: 15.0);
  final _formKey = GlobalKey<FormState>();
  BuildContext _scaffoldContext;
  final db = DbChurch();

  final _textAmmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cierre"),
        centerTitle: false,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              save(context);
            },
            child: Text("Guardar"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: new Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                  Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 0.0,
                  ),
                    child: userInfo(),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: _textAmmountController,
                    style: style,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: "Monto",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
    );
  }

  Widget userInfo(){
    return Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(
                left: 46.0,
                bottom: 26.0
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 70.0, top: 10.0, right: 10.0, bottom: 20.0,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Hero(
                      tag: "name${widget.userLogged.name}",
                      child: Text(
                        "${widget.userLogged.name}",
                        style: TextStyle(fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',),
                      ),
                    ),
                    Divider(height: 20.0,),
                    Text(
                        widget.userLogged.email,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Lato'
                        )
                    ),
                  ]
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: 26.0
            ),
            child: Hero(
              tag: "avatar${widget.userLogged.email}",
              child: CircleAvatar(
                backgroundImage: Utils.imageP(widget.userLogged.photoURL),
                maxRadius: 46.0,
              ),
            ),
          )
        ],
      );
  }

  save(BuildContext context){
    final FormState form = _formKey.currentState;
    if(form.validate()){
      form.save();

      Scaffold
          .of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text("Registro de pago en proceso"),duration: Duration(minutes: 4),));

      PaymentAddmission paymentAddmission = PaymentAddmission(
        userid: widget.userLogged.uid,
        eventid: widget.eventModel.id,
        amount: double.parse( _textAmmountController.text.toString() )
      );

      db.addPaymentAdmission(paymentAddmission).whenComplete((){
        print("GUARDO ");
        Scaffold.of(_scaffoldContext).removeCurrentSnackBar();
        Scaffold
            .of(_scaffoldContext)
            .showSnackBar(
            SnackBar(
              content: Text("Information saved success!"),
            )
        );
        Navigator.pop(_scaffoldContext);
      });
    }
  }
}