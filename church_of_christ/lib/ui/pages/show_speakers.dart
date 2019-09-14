
import 'dart:io';

import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/pages/add_speaker.dart';
import 'package:church_of_christ/ui/widgets/animated_content.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/speaker_item.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ShowSpeakers extends StatefulWidget {
  User user;

  ShowSpeakers(this.user);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowSpeakers();
  }
}

class _ShowSpeakers extends State<ShowSpeakers>{
  BuildContext _scaffoldContext;
  var db = DbChurch();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => DbChurch(),
      child: _getBodyBlanckPage(context),
    );
  }

  Widget _getListSpeaker(BuildContext context, orientation, List<SpeakerItem> speakerlist) {
    return Stack(children: <Widget>[
      ListView.builder(
          padding: EdgeInsets.only(top: 20.0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: speakerlist.length,
          itemBuilder: (context, index) {
            return speakerlist[index].getWidget(
                context,
                orientation,
                onTapCallback: (context, TalkBoss boss) {
                  if(widget.user != null)
                    if(widget.user.isAdmin){
                      Navigator.of(context).push(
                          FadeRoute(
                              AddSpeaker(
                                speakerLoad: Speaker(
                                  id: boss.speaker.id,
                                  name: boss.speaker.name,
                                  bio: boss.speaker.bio,
                                  company: boss.speaker.company,
                                  twitter: boss.speaker.twitter,
                                  fb: boss.speaker.fb,
                                  imagePath: boss.speaker.imagePath,
                                ),
                                user: widget.user,
                              )
                          )
                      );
                    }
                }
            );
          }
      )
    ]);
  }

  Widget _getBodyBlanckPage(BuildContext context){
    _scaffoldContext = context;

    return Scaffold(
        body: BlanckPage(
              title: FlutterI18n.translate(context, 'acuedd.speakers.title'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: (){
                    showSearch(context: context, delegate: SpeakerSearchDelegate(widget.user));
                  },
                ),
                PopupSettins()
              ],
            body: OrientationBuilder(builder: (context, orientation) {
              return Container(
              color: Theme
                  .of(context)
                  .backgroundColor,
                  child: StreamBuilder(
                    stream: db.streamSpeakers(),
                    builder: (context, AsyncSnapshot snapshot){
                      if(snapshot.hasData){
                        List<SpeakerItem> _speakerList =[];
                        _speakerList = db.buildSpeakers(snapshot.data.documents);
                        return _getListSpeaker(context, orientation, _speakerList);
                      }

                      return CircularProgressIndicator();
                    },
                  ),
              );
            }),
        ),
          floatingActionButton: (widget.user != null)? FloatingActionButton(
            heroTag: "btnShowSpeak",
            child: Icon(Icons.add),
            tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.search'),
            onPressed: (){
              ImagePicker.pickImage(source: ImageSource.gallery).then((File image){
                Navigator.of(context).push(FadeRoute(AddSpeaker( speakerLoad: null, user: widget.user, image: image

                )));
              }).catchError((onError) => print(onError));
            },
          ) : Column()
    );
  }
}

class SpeakerSearchDelegate extends SearchDelegate{

  User user;
  var db = DbChurch();

  SpeakerSearchDelegate(this.user);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    if(query.length < 3){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
                FlutterI18n.translate(context, 'acuedd.events.search.searchMin')
            ),
          ),
        ],
      );
    }

    return StreamBuilder(
            stream: db.streamSpeakers(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator(),)
                  ],
                );
              }
              else {
                var queryResultSet = [];
                var tmpSearchStore = [];
                var eventsListSnapshot = snapshot.data.documents;

                eventsListSnapshot.forEach((p) {
                  var mymap = p.data;
                  mymap["docID"] = p.documentID;
                  tmpSearchStore.add(TalkBoss.fromMap(mymap));
                });

                tmpSearchStore.forEach((q){
                  String searchValue = query.toLowerCase();
                  print(q.runtimeType);
                  print(q.speaker.name);
                  if(q.speaker.name.toString().toLowerCase().contains(searchValue)){
                    queryResultSet.add(SpeakerItem(q));
                  }
                });


                return ListView.builder(
                      padding: const EdgeInsets.only(top: 20.0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: queryResultSet.length,
                      itemBuilder: (context, index){
                        return queryResultSet[index].getWidget(
                          context, Orientation.portrait, onTapCallback: (context, TalkBoss boss){
                            if(user.isAdmin){
                              Navigator.of(context).push(
                                  FadeRoute(
                                      AddSpeaker(
                                        speakerLoad: Speaker(
                                          id: boss.speaker.id,
                                          name: boss.speaker.name,
                                          bio: boss.speaker.bio,
                                          company: boss.speaker.company,
                                          twitter: boss.speaker.twitter,
                                          fb: boss.speaker.fb,
                                          imagePath: boss.speaker.imagePath,
                                        ),
                                        user: user,
                                      )
                                  )
                              );
                            }
                          }
                        );
                      }
                    );
              }
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Column();
  }

}