

import 'package:church_of_christ/data/classes/abstract/list_item.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/widgets/card_page.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/row_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:row_collection/row_collection.dart';
import 'package:row_collection/row_collection.dart';

class AdmissionListWidget extends StatefulWidget{

  final EventModel myEvent;
  final User myUserLogged;

  AdmissionListWidget({
    Key key,
    this.myEvent,
    this.myUserLogged,
  });

  @override
  State createState() {
    return AdmissionListWidgetState();
  }
}

class AdmissionListWidgetState extends State<AdmissionListWidget>{
  var db = DbChurch();

  @override
  Widget build(BuildContext context) {
    return _getScaffold();
  }
  
  Widget _getScaffold(){
    return Scaffold(
      body: BlanckPage(
        title: FlutterI18n.translate(context, 'acuedd.events.list'),
        actions: <Widget>[
          PopupSettins()
        ],
        body: StreamBuilder(
          stream: (widget.myUserLogged != null)
              ? db.streamAdmisionByUser(widget.myEvent, widget.myUserLogged)
              : db.streamAdmission(widget.myEvent),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              List<DocumentSnapshot> myListaddmission = snapshot.data.documents;
              var myMap = Map();
              myMap["howMany"] = 0;
              myMap["sumTotal"] = 0;
              List<RegisterEvent> listAdmissions = [];
              myListaddmission.forEach((p){
                RegisterEvent registerEvent = RegisterEvent.fromFirestore(p);
                myMap["howMany"] += 1;
                myMap["sumTotal"] += registerEvent.price;
                listAdmissions.add(registerEvent);
              });

              return Column(
                children: [
                  getResumenWidget(context, myMap),
                  HeaderText(text:FlutterI18n.translate(
                    context,
                    'acuedd.events.registerAdmission',
                  )),
                  Expanded(
                    child: ListAdmission( listAdmissions, widget.myUserLogged),
                  )
                ],
              );
            }
            return Container(child: Center(child: CircularProgressIndicator()));
          },
        )
      )
    );
  }

  Widget getResumenWidget(BuildContext context, myMap){
    return CardPage.body(
      title: "Resumen de entradas registradas",
      body: RowLayout(
        children: <Widget>[
          RowText(
            "Conteo de entradas: ",
            myMap["howMany"].toString()
          ),
          RowText(
            "Total recaudado: ",
            myMap["sumTotal"].toString()
          )
        ],
      ),
    );
  }
}

class ListAdmission extends StatelessWidget {
  final List<RegisterEvent> listAdmissions;
  final User userlogged;
  ListAdmission(this.listAdmissions, this.userlogged);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: RowLayout(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0, bottom: 25.0),
        children: <Widget>[
          RowText(
            "${FlutterI18n.translate(context, 'acuedd.events.name')}:",
            listAdmissions[index].name,
          ),
          RowText(
            "${FlutterI18n.translate(context, 'acuedd.events.church')}:",
            listAdmissions[index].church,
          ),
          RowText(
            "${FlutterI18n.translate(context, 'acuedd.events.contribution')}:",
            "${listAdmissions[index].currency} ${listAdmissions[index].price.toString()}",
          ),
          if(userlogged == null)
            RowText(
              "${FlutterI18n.translate(context, 'app.regby')}:",
              "${listAdmissions[index].nameUserReg}"
            )
          //Text(, style: TextStyle(color: Colors.deepPurple))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildProductItem,
      itemCount: listAdmissions.length,
    );
  }
}


