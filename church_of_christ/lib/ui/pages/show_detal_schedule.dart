
import 'package:church_of_christ/data/classes/abstract/list_item.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/schedule.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/talk_item.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleWidget extends StatefulWidget{
  final List<ScheduleModel> scheduleList;

  ScheduleWidget({
    Key key,
    this.scheduleList,
  });

  @override
  State<ScheduleWidget> createState() => ScheduleWidgetState();
}

class ScheduleWidgetState extends State<ScheduleWidget>{
  List _scheduleList = [];
  var db = DbChurch();

  @override
  Widget build(BuildContext context) {


    print("widget.scheduleList");
    print(widget.scheduleList);

    var dataList = new Map();
    widget.scheduleList.forEach((p){
      String _time = '${p.dateTime.hour.toString().padLeft(2,'0')}:${p.dateTime.minute.toString().padLeft(2,'0')}:${p.dateTime.second.toString().padLeft(2,'0')}';
      if(!dataList.containsKey(_time)){
        dataList[_time] = List<ScheduleModel>();
      }
      dataList[_time].add(p);
    });

    print("dataList");
    print(dataList);

    return BlanckPage(
      title: "Horario detalle",
      body: OrientationBuilder(builder: (context, orientation) {
          _scheduleList = [];

          return Container(
            child: Stack(children: <Widget>[
              ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: widget.scheduleList.length,
                  itemBuilder: (context, index){
                    ScheduleModel _scheduleitem = widget.scheduleList[index];
                    String _time = '${_scheduleitem.dateTime.hour.toString().padLeft(2,'0')}:${_scheduleitem.dateTime.minute.toString().padLeft(2,'0')}:${_scheduleitem.dateTime.second.toString().padLeft(2,'0')}';
                    return Stack(

                      children: <Widget>[
                        getTalkTime(context,_time),
                        getTalkTrack(context, _scheduleitem, orientation, _time),
                      ],
                    ) ;
                  }
              )
            ]),
          );
        }),
    );
  }

  Widget getTalkTime(BuildContext context, _time ){
    if(!_scheduleList.contains(_time)){
      _scheduleList.add(_time);
      return TitleItem(_time).getWidget(context, Orientation.portrait);
    }
    _scheduleList.add(_time);
    return Container();
  }

  Widget getTalkTrack(BuildContext context, ScheduleModel scheduleModel, Orientation orientation, _time){
    print("_scheduleList");
    //print(_scheduleList);
    var map = Map();
    _scheduleList.forEach((element) {
      if(!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] +=1;
      }
    });
    print(map);

    return Card(
        elevation: 12.0,
        margin: EdgeInsets.only(
        left: Utils.getOrientationSideMargin(orientation),
        right: Utils.getOrientationSideMargin(orientation),
        top: (map[_time] <= 1)?35.0:0.0,
        bottom: 20.0),
        child: _createTalk(context, scheduleModel, orientation, _time)
    );
  }

  Widget _createTalk (context, ScheduleModel scheduleModel, Orientation orientation, _time){

    if(scheduleModel.speakerTalk != null && scheduleModel.speakerTalk.length >0) {
      return Padding(
        padding: EdgeInsets.only(
            left: 20.0, top: 20.0, right: 20.0, bottom: 20.0
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${scheduleModel.title}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: Hero(
                                  tag: "avatar${scheduleModel
                                      .id}_${scheduleModel.speakerTalk}",
                                  child: CircleAvatar(
                                    maxRadius: 30.0,
                                    backgroundImage: Utils.imageP(
                                        scheduleModel.avatarSpeaker),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text('${scheduleModel.nameSpeaker}',
                                        style: TextStyle(fontSize: 18.0),),
                                      Divider(height: 40.0),
                                      if(scheduleModel.tag.isNotEmpty)
                                        Text('${scheduleModel.tag}',
                                          style: TextStyle(color: hexToColor(scheduleModel.colorTag)),)
                                    ]),
                              ),
                              Spacer(),
                            ]),
                      )
                    ]),
              )
            ]),
      );
    }
    else{
      return Container(
        child: InkWell(
          onTap: (){
            
          },
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(children: <Widget>[
              _getNonSpeakerRow(context, scheduleModel, orientation, _time),
            ]),
          ),
        ),
      );
    }
  }

  Widget _getNonSpeakerRow(context, ScheduleModel scheduleModel, Orientation orientation, _time){
    return Expanded(
      child: Text(
        '${scheduleModel.title}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22.0),
      ),
    );
  }

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}