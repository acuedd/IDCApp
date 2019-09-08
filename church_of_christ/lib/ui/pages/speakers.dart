
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/speaker_item.dart';
import 'package:flutter/material.dart';

class DetailSpeakers extends StatelessWidget{

  final List<SpeakerItem> speakerList;

  DetailSpeakers({
    Key key,
    @required this.speakerList,
  });

  @override
  Widget build(BuildContext context) {
    return _getPageBlanck(context);
  }

  Widget _getPageBlanck(BuildContext context){
    return BlanckPage(
      title: "Speakers",//FlutterI18n.translate(context, 'Profile'),
      actions: <Widget>[
        PopupSettins(),
      ],
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
            color: Theme.of(context).backgroundColor,
            child: Stack(children: <Widget>[
              ListView.builder(
                padding: EdgeInsets.only(top: 20.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: speakerList.length,
                itemBuilder: (context, index){
                  return speakerList[index].getWidget(
                    context,
                    orientation,
                    onTapCallback: (){
                      print("FUCK YEA");
                    });
                }
              ),
            ])
          );
      })
    );
  }

  Widget getCardSpeaker(){

  }
}

