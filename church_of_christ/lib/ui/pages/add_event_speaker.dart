
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/speaker_item.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class AssignSpeakerEvent extends StatefulWidget{
  User user;
  EventModel eventModel;

  AssignSpeakerEvent({
    Key key,
    this.user,
    this.eventModel,
  });

  @override
  State createState() {
    return _AssignSpeakerEvent();
  }
}

class _AssignSpeakerEvent extends State<AssignSpeakerEvent>{
  BuildContext _scaffoldContext;
  var db = DbChurch();


  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => DbChurch(),
      child: _getBodyBlanckPage(context),
    );
  }

  Future<List<AugmentedSpeaker>> _getSpeakers(EventModel eventModel) async{
    //print(list);
    var promises =List<Future>();

    var eventReload = await db.getEventData(eventModel.id);
    List<AugmentedSpeaker> oficialList = [];

    eventReload.spearkers.forEach((val){
      //print("ID ALL");
      //print(val);
      var promise = db.getSpeaker(val)
          .then((AugmentedSpeaker sp){
        //print("im here");
        //print(sp.id);
        setState(() {
          oficialList.add(sp);
        });
        return oficialList;
      }).catchError((error)=>{
        //print("ERROR"),
        //print(error),
      });

      promises.add(promise);
    });

    await Future.wait(promises);
/**/
    //print('All the futures has completed');
    //print(oficialList);
    return oficialList;
  }

  Widget _getBodyBlanckPage(BuildContext context){
    _scaffoldContext = context;
    return BlanckPage(
        title: FlutterI18n.translate(context, 'acuedd.speakers.title'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: SpeakerSearchDelegate(widget.user, widget.eventModel, _scaffoldContext));
            },
          ),
          PopupSettins()
        ],
        body: OrientationBuilder(builder: (context, orientation) {
          return Container(
            child: FutureBuilder(
                future: _getSpeakers(widget.eventModel),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  }
                  else {
                    var spList = _buildSpeaker(snapshot);
                    return _getListSpeaker(context,orientation,spList);
                  }
                }
            ),
          );
        })
    );
  }

  _buildSpeaker(AsyncSnapshot snapshot){

    List<SpeakerItem> speakerList = List<SpeakerItem>();
    var map = snapshot.data;
    if(map != null){
      for(var i=0; i < map.length; ++i){
        speakerList.add(SpeakerItem(TalkBoss(map[i], null,null)));
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
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: FlutterI18n.translate(context, 'app.delete'),
                color: Colors.red,
                icon: Icons.delete,
                onTap: (){
                  db.removeSpeakerToEvent(speakerlist[index].boss.speaker,widget.eventModel);
                  //_delteEvent();
                },
              ),
            ]
          );
        },
      )
    ],);
  }
}

class SpeakerSearchDelegate extends SearchDelegate{

  User user;
  EventModel eventModel;
  BuildContext _context;
  var db = DbChurch();

  SpeakerSearchDelegate(this.user, this.eventModel, this._context);

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
            if(q.speaker.name.toString().toLowerCase().contains(searchValue)){
              queryResultSet.add(SpeakerItem(q));
            }
          });


          return _getItemReturn(queryResultSet);
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
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
            var eventsListSnapshot = snapshot.data.documents;

            eventsListSnapshot.forEach((p) {
              var mymap = p.data;
              mymap["docID"] = p.documentID;
              queryResultSet.add(SpeakerItem(TalkBoss.fromMap(mymap)));
            });

            return _getItemReturn(queryResultSet);

          }
      });
    }

    Widget _getItemReturn(queryResultSet){
      return ListView.builder(
          padding: const EdgeInsets.only(top: 25.0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: queryResultSet.length,
          itemBuilder: (context, index) {
            return new Slidable(
              actionPane: new SlidableScrollActionPane(),
              actionExtentRatio: 0.20,
              child:
              queryResultSet[index].getWidget(
                  context, Orientation.portrait, onTapCallback: (context, TalkBoss boss){
                //TODO IF YOU NEED ON TAP
              }),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: FlutterI18n.translate(context, 'app.add'),
                  icon: Icons.person_add,
                  onTap: (){
                    TalkBoss itemicon = queryResultSet[index].boss;
                    db.addSpeakerToEvent(itemicon.speaker, eventModel);
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    }

}