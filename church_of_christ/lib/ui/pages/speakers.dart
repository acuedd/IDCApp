
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/speaker_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DetailSpeakers extends StatelessWidget{
  final EventModel eventModel;

  DetailSpeakers({
    Key key,
    @required this.eventModel,
  });

  BuildContext _scaffoldContext;
  var db = DbChurch();

  @override
  Widget build(BuildContext context) {
    return _getPageBlanck(context);
  }

  Future<List<AugmentedSpeaker>> _getSpeakers() async{
    var promises =List<Future>();
    List<AugmentedSpeaker> oficialList = [];

    eventModel.spearkers.forEach((val){
      promises.add(
        db.getSpeaker(val)
            .then((AugmentedSpeaker sp){
              oficialList.add(sp);
              return oficialList;
        }).catchError((error) =>{
          print(error)
        })
      );
    });
    await Future.wait(promises);

    return oficialList;
  }

  Widget _getPageBlanck(BuildContext context){
    _scaffoldContext = context;

    return BlanckPage(
      title: "Expositores",
      actions: <Widget>[
        PopupSettins(),
      ],
      body: OrientationBuilder( builder: (context, orientation){
        return Container(
          child: FutureBuilder(
            future: _getSpeakers(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasError){
                return Container(child: Center( child: CircularProgressIndicator(),),);
              }
              else{
                var spList = _buildSpeaker(snapshot);
                return _getListSpeaker(context, orientation, spList);
              }
            },
          ),
        );
      }),
    );
  }

  _buildSpeaker(AsyncSnapshot snapshot){
    List<SpeakerItem> speakerList = List<SpeakerItem>();
    var map = snapshot.data;
    if(map != null){
      for(var i=0; i < map.length; ++i){
        speakerList.add(SpeakerItem(TalkBoss(map[i], null, null)));
      }
    }

    return speakerList;
  }

  _getListSpeaker(BuildContext context, orientation, List<SpeakerItem> speakerlist){
    return Stack(children: <Widget>[
      ListView.builder(
        padding: EdgeInsets.only(top: 20.0),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: speakerlist.length,
        itemBuilder: (context, index){
          return Slidable(
              actionPane: new SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: speakerlist[index].getWidget(
                  context, orientation,
                  onTapCallback: (context, TalkBoss boss){
                    //TODO if i want make something
                    print("tap boss");
                  }
              ),
          );
        },
      )
    ],);
  }
}

