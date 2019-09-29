import 'package:church_of_christ/data/classes/abstract/list_item.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/ui/widgets/reusable.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';

class TalkItem implements ListItem{

  final List<TalkBoss> talks;

  TalkItem(this.talks);

  @override
  Object getWidget(context, Orientation orientation, {Function onTapCallback}) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(
        left: Utils.getOrientationSideMargin(orientation),
        right: Utils.getOrientationSideMargin(orientation),
        top: 4.0,
        bottom: 26.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: talks.map((t)=> _createTalk(context, t, onTapCallback))
          .toList()
      ),
    );
  }

  Widget _createTalk(context, TalkBoss boss, Function onTapCallback){
    if(boss.speaker != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: (){
              onTapCallback(context, boss);
            },
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${boss.currentTalk.title}',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Hero(
                                tag: "avatar${boss.speaker.id}",
                                child: CircleAvatar(
                                  maxRadius: 30.0,
                                  // TODO: Conditional lookup to replace with Icons.person
                                  // if no imagePath exists
                                  backgroundImage:
                                  Utils.imageP(boss.speaker.imagePath),
                                ))),
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${boss.speaker.name}',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  '${boss.speaker.company}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color),
                                ),
                                talks.length > 1
                                    ? Container(
                                    margin: EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      '${boss.currentTalk.track.name}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Utils.convertIntColor(
                                              boss.currentTalk.track
                                                  .color)),
                                    ))
                                    : Container()
                              ],
                            )),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              Reusable.showSnackBar(context,
                                  boss.currentTalk.talkType.description);
                            },
                            child: CircleAvatar(
                                backgroundColor:
                                Theme.of(context).accentColor,
                                child: Icon(
                                  getMaterialIcon(
                                      name: boss.currentTalk.talkType
                                          .materialIcon),
                                  color: Colors.white,
                                )))
                      ],
                    ),
                  ),
                  talks.length > 1 && talks.last != boss
                      ? Divider(height: 4.0)
                      : Container(),
                ],
              ),
            ),
          )
        ],
      );
    }
    else{
      return Container(
        child: InkWell(
          onTap: (){
            if(boss.currentTalk.description != null){
              onTapCallback(context, boss);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(children: _getNonSpeakerRow(context, boss),),
          ),
        ),
      );
    }
  }

  List<Widget> _getNonSpeakerRow(context, boss) {

  }
}

class TitleItem implements ListItem{

  final String title;

  TitleItem(this.title);

  @override
  Row getWidget(context, Orientation orientation, {Function onTapCallback}) {
    return Row(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: Utils.getOrientationSideMargin(orientation), bottom: 10.0),
        child: Text("$title",
          style: TextStyle(
            fontSize: 20.0,
            //color:
            letterSpacing: 1.2,
            height: 1.2
          ),
        ),
      )
    ],);
  }
}