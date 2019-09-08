

import 'package:church_of_christ/data/classes/abstract/list_item.dart';
import 'package:church_of_christ/data/models/app_model.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/ui/widgets/card_page.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeakerItem implements ListItem{
  final TalkBoss boss;

  SpeakerItem(this.boss);


  @override
  Object getWidget(context, Orientation orientation, {Function onTapCallback}) {
    return GestureDetector(
      onTap: (){
        onTapCallback(context, boss);
      },
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Provider.of<AppModel>(context).theme == Themes.black
                      ? Theme.of(context).dividerColor
                      : Colors.transparent,
                )
            ),
            margin: EdgeInsets.only(
              left: 46.0 + Utils.getOrientationSideMargin(orientation),
              right: Utils.getOrientationSideMargin(orientation),
              bottom: 26.0
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 70.0, top: 20.0, bottom: 20.0
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Hero(
                    tag: "name${boss.speaker.id}",
                    child: Text(
                      "${boss.speaker.name}",
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                  Divider(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Utils.getOrientationSideMargin(orientation),
              bottom: 26.0
            ),
            child: Hero(
              tag: "avatar${boss.speaker.id}",
              child: CircleAvatar(
                backgroundImage: Utils.imageP(boss.speaker.imagePath),
                maxRadius: 46.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}