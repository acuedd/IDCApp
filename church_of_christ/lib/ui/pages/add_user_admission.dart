

import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/pages/admissions_list.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/speaker_item.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class AssignUserEvent extends StatefulWidget{
  User user;
  EventModel eventModel;

  AssignUserEvent({
    Key key,
    this.user,
    this.eventModel,
  });

  @override
  State createState() {
    return _AssignUserEvent();
  }
}

class _AssignUserEvent extends State<AssignUserEvent>{
  BuildContext _scaffoldContext;
  var db = DbChurch();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => DbChurch(),
      child: _getBodyBlanckPage(context),
    );
  }

  Future<List<Map>> _getUsers(EventModel eventModel) async{
    var promises = List<Future>();

    var eventReload = await db.getEventData(eventModel.id);
    List<Map> oficialList = [];

    eventReload.admissions.forEach((val){
      var promise = db.getUser(val)
        .then(( User user){
          var myMap = Map();
          myMap["docID"] = user.uid;
          myMap["name"] = user.name;
          myMap["bio"] = user.email;
          myMap["imagePath"] = user.photoURL;

          AugmentedSpeaker sp = AugmentedSpeaker.fromMap(myMap);
          setState(() {
            var mapData = Map();
            mapData["speaker"] = sp;
            mapData["user"] = user;
            oficialList.add(mapData);
          });
          return oficialList;
        })
        .catchError((error){
          //print("ERROR"),
          //print(error),
        });

      promises.add(promise);
    });

    await Future.wait(promises);

    return oficialList;
  }

  Widget _getBodyBlanckPage(BuildContext context){
    _scaffoldContext = context;
    return BlanckPage(
      title: FlutterI18n.translate(context, 'acuedd.events.admissions'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            showSearch(context: context, delegate: UserSearchDelegate(widget.user, widget.eventModel, _scaffoldContext));
          },
        ),
        PopupSettins()
      ],
        body: OrientationBuilder(builder: (context, orientation) {
          return Container(
            child: FutureBuilder(
                future: _getUsers(widget.eventModel),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  }
                  else {
                    return _buildUser(snapshot, orientation);
                  }
                }
            ),
          );
        })
    );
  }

  _buildUser(AsyncSnapshot snapshot, Orientation orientation){

    List<SpeakerItem> speakerList = List<SpeakerItem>();
    List<User> userList = List<User>();
    var map = snapshot.data;
    if(map != null){
      for(var i=0; i < map.length; ++i){
        speakerList.add(SpeakerItem(TalkBoss(map[i]["speaker"], null,null)));
        userList.add(map[i]["user"]);
      }
    }

    return _getListUser(context,orientation,speakerList, userList);
  }

  _getListUser(BuildContext context, orientation, List<SpeakerItem> speakerlist, List<User> userList){

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
                print("tap boss");
              }
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: FlutterI18n.translate(context, 'acuedd.events.tickets.payment'),
                color: Colors.blueAccent,
                icon: Icons.payment,
                onTap: (){
                  //TODO ir para registrar pago
                },
              ),
              IconSlideAction(
                caption: FlutterI18n.translate(context, 'acuedd.events.tickets.report'),
                color: Colors.grey,
                icon: Icons.report,
                onTap: (){
                  Navigator.of(_scaffoldContext).push(FadeRoute(AdmissionListWidget(
                    myEvent: widget.eventModel,
                    myUserLogged: userList[index],
                  )));
                },
              )
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: FlutterI18n.translate(context, 'app.delete'),
                color: Colors.red,
                icon: Icons.delete,
                onTap: (){
                  //TODO delete admision user
                  db.removeAdmissionToEvent(speakerlist[index].boss.speaker, widget.eventModel);
                },
              )
            ],
          );
        }
      ),
    ]);
  }

}

class UserSearchDelegate extends SearchDelegate{

  User user;
  EventModel eventModel;
  BuildContext _context;
  var db = DbChurch();

  UserSearchDelegate(this.user, this.eventModel, this._context);

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
      stream: db.streamUsers(),
      builder: (context, AsyncSnapshot snapshot){
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator(),)
            ],
          );
        }
        else{
          var queryResultSet = [];
          var tmpSearchStore = [];
          var eventsListSnapshot = snapshot.data.documents;

          eventsListSnapshot.forEach((p) {
            var mymap = p.data;
            mymap["docID"] = p.documentID;
            mymap["name"] = p.data["name"];
            mymap["bio"] = p.data["email"];
            mymap["imagePath"] = p.data["photoURL"];
            tmpSearchStore.add(TalkBoss.fromMap(mymap));
          });

          tmpSearchStore.forEach((q){
            String searchValue = query.toLowerCase();
            if(q.speaker.name.toString().toLowerCase().contains(searchValue)){
              queryResultSet.add(SpeakerItem(q));
            }
            else{
              if(q.speaker.bio.toString().toLowerCase().contains(searchValue)){
                queryResultSet.add(SpeakerItem(q));
              }
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
        stream: db.streamUsers(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            print("FFF");
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

            int i = 0;
            eventsListSnapshot.forEach((p) {
              if(p.documentID != user.uid){
                var mymap = p.data;
                mymap["docID"] = p.documentID;
                mymap["name"] = p.data["name"];
                mymap["bio"] = p.data["email"];
                mymap["imagePath"] = p.data["photoURL"];

                if(i <= 24){
                  queryResultSet.add(SpeakerItem(TalkBoss.fromMap(mymap)));
                }
                i++;
              }
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
                  db.addUserToEvent(itemicon.speaker, eventModel);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }


}