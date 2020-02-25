

import 'package:church_of_christ/data/classes/abstract/list_item.dart';
import 'package:church_of_christ/data/models/app_model.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/pages/admissions_detail.dart';
import 'package:church_of_christ/ui/widgets/card_page.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/list_cell.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/row_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold();
  }
  
  Widget _getScaffold(){
    return Scaffold(
      body: BlanckPage(
        title: FlutterI18n.translate(context, 'acuedd.events.statistics'),
        actions: <Widget>[
          PopupSettins()
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: (widget.myUserLogged == null)
                ? db.streamAdmission(widget.myEvent)
                : db.streamAdmisionByUser(widget.myEvent, widget.myUserLogged),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List<DocumentSnapshot> myListaddmission = snapshot.data.documents;
                var myMap = Map();
                myMap["howMany"] = 0;
                myMap["sumTotal"] = 0;
                Map<String, double> mapCivilStatus = Map();
                Map<String, double> mapAge = Map();
                Map<String, double> mapRangeAge = Map();
                Map<String, double> mapGender = Map();
                List<RegisterEvent> listAdmissions = [];
                myListaddmission.forEach((p){
                  RegisterEvent registerEvent = RegisterEvent.fromFirestore(p);
                  //add Map to civil status
                  if(mapCivilStatus.containsKey(registerEvent.civilStatus)){
                    mapCivilStatus[registerEvent.civilStatus] += 1;
                  }
                  else{
                    mapCivilStatus[registerEvent.civilStatus] = 1;
                  }

                  //add Map to age
                  if(mapAge.containsKey(registerEvent.age.toString())){
                    mapAge[registerEvent.age.toString()] += 1;
                  }
                  else{
                    mapAge[registerEvent.age.toString()] = 1;
                  }

                  if(registerEvent.age > 0 && registerEvent.age <= 10){
                    //add Map to age
                    if(mapRangeAge.containsKey("0-10")){
                      mapRangeAge["0-10"] += 1;
                    }
                    else{
                      mapRangeAge["0-10"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 11 && registerEvent.age <= 20){
                    //add Map to age
                    if(mapRangeAge.containsKey("11-20")){
                      mapRangeAge["11-20"] += 1;
                    }
                    else{
                      mapRangeAge["11-20"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 21 && registerEvent.age <= 30){
                    //add Map to age
                    if(mapRangeAge.containsKey("21-30")){
                      mapRangeAge["21-30"] += 1;
                    }
                    else{
                      mapRangeAge["21-30"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 31 && registerEvent.age <= 40){
                    //add Map to age
                    if(mapRangeAge.containsKey("31-40")){
                      mapRangeAge["31-40"] += 1;
                    }
                    else{
                      mapRangeAge["31-40"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 41 && registerEvent.age <= 50){
                    //add Map to age
                    if(mapRangeAge.containsKey("41-50")){
                      mapRangeAge["41-50"] += 1;
                    }
                    else{
                      mapRangeAge["41-50"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 51 && registerEvent.age <= 60){
                    //add Map to age
                    if(mapRangeAge.containsKey("51-60")){
                      mapRangeAge["51-60"] += 1;
                    }
                    else{
                      mapRangeAge["51-60"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 61 && registerEvent.age <= 70){
                    //add Map to age
                    if(mapRangeAge.containsKey("61-70")){
                      mapRangeAge["61-70"] += 1;
                    }
                    else{
                      mapRangeAge["61-70"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 71 && registerEvent.age <= 80){
                    //add Map to age
                    if(mapRangeAge.containsKey("71-80")){
                      mapRangeAge["71-80"] += 1;
                    }
                    else{
                      mapRangeAge["71-80"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 81 && registerEvent.age <= 90){
                    //add Map to age
                    if(mapRangeAge.containsKey("81-90")){
                      mapRangeAge["81-90"] += 1;
                    }
                    else{
                      mapRangeAge["81-90"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 91 && registerEvent.age <= 100){
                    //add Map to age
                    if(mapRangeAge.containsKey("91-100")){
                      mapRangeAge["91-100"] += 1;
                    }
                    else{
                      mapRangeAge["91-100"] = 1;
                    }
                  }
                  else if(registerEvent.age >= 101 && registerEvent.age <= 110){
                    //add Map to age
                    if(mapRangeAge.containsKey("101-110")){
                      mapRangeAge["101-110"] += 1;
                    }
                    else{
                      mapRangeAge["101-110"] = 1;
                    }
                  }

                  //add Map to gender
                  if(registerEvent.gender == "female"){
                    if(mapGender.containsKey("Femenino")){
                      mapGender["Femenino"] += 1;
                    }
                    else{
                      mapGender["Femenino"] = 1;
                    }
                  }
                  else{
                    if(mapGender.containsKey("Masculino")){
                      mapGender["Masculino"] += 1;
                    }
                    else{
                      mapGender["Masculino"] = 1;
                    }
                  }

                  myMap["howMany"] += 1;
                  myMap["sumTotal"] += registerEvent.price;
                  listAdmissions.add(registerEvent);
                });

                myMap["civilStatus"] = mapCivilStatus;
                myMap["age"] = mapRangeAge;
                myMap["gender"] = mapGender;

                return Column(
                  children: [
                    getResumenWidget(context, myMap),
                    ListCell.icon(
                      icon: Icons.list,
                      title: FlutterI18n.translate(context, 'acuedd.events.list'),
                      subtitle: FlutterI18n.translate(context, 'acuedd.events.admissions'),
                      trailing: Icon(Icons.chevron_right),
                      onTap:(){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AdmissionsDetail(
                                myUserLogged: widget.myUserLogged,
                                myEvent: widget.myEvent,
                                listAdmissions: listAdmissions,
                              ),
                            )
                        );
                      },
                    ),
                    Separator.divider(indent: 72),
                    getCharts(context, myMap),
                  ],
                );
              }

              return Container(child: Center(child: CircularProgressIndicator()));
            },
          )
        )
      )
    );
  }


  Widget getCharts(BuildContext context, myMap){
    Map<String, double> civilStatusMap = myMap["civilStatus"];
    Map<String, double> ageMap = myMap["age"];
    Map<String, double> genderMap = myMap["gender"];

    print(Theme.of(context).primaryColor);

    List<Color> colorList = [
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.grey,
      Colors.cyanAccent,
      Colors.deepPurple,
      Colors.red,
      Colors.blueGrey,
      Colors.blueAccent,
    ];

    return Column(
          children: <Widget>[
                HeaderText(text:FlutterI18n.translate(
                  context,
                  'acuedd.events.statisticsCivilStatus',
                )),
                PieChart(
                  dataMap: civilStatusMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32.0,
                  chartRadius: MediaQuery
                      .of(context)
                      .size
                      .width / 2.7,
                  colorList: colorList,
                  showChartValuesInPercentage: true,
                  showChartValues: true,
                  showChartValuesOutside: false,
                  chartValueBackgroundColor: Colors.grey[200],
                ),
                HeaderText(text:FlutterI18n.translate(
                  context,
                  'acuedd.events.statisticsAge',
                )),
                PieChart(
                  dataMap: ageMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32.0,
                  /*chartRadius: MediaQuery
                      .of(context)
                      .size
                      .width / 1,*/
                  colorList: colorList,
                  showChartValuesInPercentage: false,
                  showLegends: true,
                  showChartValues: true,
                  showChartValuesOutside: true,
                  chartValueBackgroundColor: Colors.grey[200],
                  chartValueStyle: defaultChartValueStyle.copyWith(
                    color: Colors.blueGrey[900].withOpacity(0.9),
                  ),
                  chartType: ChartType.disc,
                ),
                HeaderText(text:FlutterI18n.translate(
                  context,
                  'acuedd.events.statisticsGender',
                )),
                PieChart(
                  dataMap: genderMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32.0,
                  chartRadius: MediaQuery
                      .of(context)
                      .size
                      .width / 2.7,
                  colorList: colorList,
                  showChartValuesInPercentage: true,
                  showChartValues: true,
                  showChartValuesOutside: false,
                  chartValueBackgroundColor: Colors.grey[200],
                ),
          ],
        );
  }

  Widget getResumenWidget(BuildContext context, myMap){

    MoneyFormatterOutput fo = FlutterMoneyFormatter(
      amount: double.parse( myMap["sumTotal"].toString() ),
      settings: MoneyFormatterSettings(
        symbol: widget.myEvent.currency,
        thousandSeparator: ',',
        decimalSeparator: '.',
      )
    ).output;

    return CardPage.body(
      title: FlutterI18n.translate(context, 'acuedd.events.tickets.resume'),
      body: RowLayout(
        children: <Widget>[
          RowText(
            FlutterI18n.translate(context, 'acuedd.events.tickets.counter'),
            myMap["howMany"].toString()
          ),
          RowText(
            FlutterI18n.translate(context, 'acuedd.events.tickets.contribution'),
            fo.symbolOnLeft
          ),
          Container(
            child: StreamBuilder(
              stream: (widget.myUserLogged == null)
                  ?db.streamIncomeAdmissions(
                    PaymentAddmission(userid: "", eventid: widget.myEvent.id)
                  )
                  :db.streamIncomeAdmissionsByUser(
                    PaymentAddmission(userid: widget.myUserLogged.uid, eventid: widget.myEvent.id)
                  ),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  var pList = snapshot.data.documents;
                  double summary = 0.0;
                  pList.forEach((p) {
                    PaymentAddmission py = PaymentAddmission.fromFirestore(p);
                    summary += py.amount;
                  });

                  MoneyFormatterOutput fo = FlutterMoneyFormatter(
                      amount: double.parse( summary.toString() ),
                      settings: MoneyFormatterSettings(
                        symbol: widget.myEvent.currency,
                        thousandSeparator: ',',
                        decimalSeparator: '.',
                      )
                  ).output;

                  return RowText(
                          FlutterI18n.translate(context, 'acuedd.events.tickets.income'),
                          fo.symbolOnLeft
                  );
                }
                else{
                  return Container(child: Center(child: CircularProgressIndicator(),),);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


