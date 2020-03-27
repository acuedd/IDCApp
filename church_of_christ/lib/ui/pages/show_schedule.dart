

import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/schedule.dart';
import 'package:church_of_christ/ui/pages/show_detal_schedule.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/list_cell.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowSchedule extends StatefulWidget{

  final EventModel eventModel;

  ShowSchedule({
    Key key,
    this.eventModel
  });

  @override
  State createState() {
    return _ShowSchedule();
  }
}

class _ShowSchedule extends State<ShowSchedule>{
  var db = DbChurch();
  BuildContext _scaffoldContext;

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;

    return BlanckPage(
      title: "Programa",
      actions: <Widget>[
        PopupSettins(),
      ],
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: _buildFeatures(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatures(){
    return StreamBuilder(
      stream: db.streamSchedule(widget.eventModel),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          var eventsListSnapshot = snapshot.data.documents;
          var fordays = new Map();
          List _destaque = [];
          eventsListSnapshot.forEach((p) {
            ScheduleModel scheduleModel = ScheduleModel.fromFirestore(p);
            String days = DateFormat.yMMMd().format(scheduleModel.dateTime);
            if(!fordays.containsKey(days)){
              fordays[days] = List<ScheduleModel>();
            }
            fordays[days].add(scheduleModel);
            if(!_destaque.contains(days)){
              _destaque.add(days);
            }
          });

          return ListView.builder(
            padding: EdgeInsets.only(top: 20.0),
            itemCount: _destaque.length,
            itemBuilder: (context, index){
              //ScheduleModel mySchedule = _destaque[index];
              return ListCell.icon(
                  icon: Icons.access_time,
                  title: _destaque[index],
                  subtitle: "dia",
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.of(context).push(FadeRoute(ScheduleWidget(scheduleList: fordays[_destaque[index]],)));
                  },
              );
            },
          );
        }

        return Container(child: Center(child: CircularProgressIndicator(),),);
      },
    );
  }

}