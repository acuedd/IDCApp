

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/ui/pages/speakers.dart';
import 'package:church_of_christ/ui/widgets/cache_image.dart';
import 'package:church_of_christ/ui/widgets/card_page.dart';
import 'package:church_of_christ/ui/widgets/circle_button.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/custom_tab.dart';
import 'package:church_of_christ/ui/widgets/expand_widget.dart';
import 'package:church_of_christ/ui/widgets/fade_in_route.dart';
import 'package:church_of_christ/ui/widgets/header_swiper.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/reusable.dart';
import 'package:church_of_christ/ui/widgets/row_item.dart';
import 'package:church_of_christ/ui/widgets/shared_item.dart';
import 'package:church_of_christ/ui/widgets/sliver_bar.dart';
import 'package:church_of_christ/ui/widgets/speaker_item.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:row_collection/row_collection.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget{

  final _formKey = GlobalKey<FormState>();
  final EventModel myEvent;
  DetailPage({
    Key key,
    this.myEvent
  });
  bool _haVideo;

  @override
  Widget build(BuildContext context) {
    _haVideo = (myEvent.urlVideo.isEmpty)?false:true;

    return _getScaffoldSliverFab(context);
  }

  Widget _getScaffoldSliverFab(BuildContext context){
    return Scaffold(
      body: SliverFab(
        expandedHeight: MediaQuery.of(context).size.height * 0.3,
        floatingWidget: _haVideo
            ? FloatingActionButton(
                heroTag:  null,
                child: Icon(Icons.ondemand_video),
                tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.watch_replay'),
                onPressed: () async => await FlutterWebBrowser.openWebPage(
                  url: myEvent.urlVideo,
                  androidToolbarColor: Theme.of(context).primaryColor,
                ),
              )
            : FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.event),
                backgroundColor: Theme.of(context).accentColor,
                tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.add_event'),
                onPressed: () => Add2Calendar.addEvent2Cal(Event(
                  title: myEvent.title,
                  description: myEvent.description ??
                    FlutterI18n.translate(context, 'app.no_description'),
                  location: myEvent.address,
                  startDate: myEvent.dateTime,
                  endDate: myEvent.dateTime.add(Duration(
                    minutes: 60
                  )),
                )),
              )
        ,
        slivers: <Widget>[
          _getSliverBar(context),
          _getSliverToBoxAdapter(context),
        ],
      )
    );
  }

  Widget _getScaffoldSliverBar(BuildContext context){

    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        _getSliverBar(context),
        _getSliverToBoxAdapter(context),
      ]),
    );
  }

  Widget _getSliverToBoxAdapter(BuildContext context){
    return SliverToBoxAdapter(
        child: RowLayout.cards(children: <Widget>[
          _getDescription(context),
          _getMoreInfo(context),
          _getLocation(context),
        ])
    );
  }

  Widget _getSliverBar(BuildContext context){
    List<String> list;
    if(myEvent.listImages == null)
      list = [myEvent.urlImage];
    else
      list = myEvent.listImages;

    return SliverBar(
      title: myEvent.title,
      header: SwiperHeader(
        list: list,
        /*builder: (context, index){
          final CacheImage photo = CacheImage(_img);
          print("index");
          print(index);
          return index == 0 ? Hero(tag: 1, child: photo,) : photo;
        },*/
      ),
      actions: <Widget>[
        SharedContent( onPressedFabIcon: () {
          print("share");
        }),
        PopupSettins(),
      ],
    );
  }

  Widget _getPageBlanck(BuildContext context){
    return BlanckPage(
      title: myEvent.title,//FlutterI18n.translate(context, 'Profile'),
      actions: <Widget>[
        SharedContent( onPressedFabIcon: () {
          print("share");
        }),
        PopupSettins(),
      ],
      body: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Material(
          elevation: 0.1,
          borderRadius: new BorderRadius.circular(6.0),
          child: new ListView(
            children: <Widget>[
              new Hero(
                  tag: myEvent.title,
                  child: _getImageNetwork(Functions.getImgResizeUrl(myEvent.urlImage,250,''))
              ),
              RowLayout.cards(children: <Widget>[
                _getDescription(context),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getImageNetwork(url){

    try{
      if(url != '') {

        return ClipRRect(
          borderRadius: new BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
          child: new Container(
            height: 200.0,
            child: new FadeInImage.assetNetwork(
              placeholder: 'assets/images/place_holder.jpg',
              image: url,
              fit: BoxFit.cover,),
          ),
        );
      }else{
        return new Container(
          height: 200.0,
          child: new Image.asset('assets/images/place_holder_3.jpg'),
        );
      }

    }catch(e){
      return new Container(
        height: 200.0,
        child: new Image.asset('assets/images/place_holder_3.jpg'),
      );
    }

  }

  Widget _getDescription(BuildContext context){
    return CardPage.body(
      title: FlutterI18n.translate(
        context,
        'acuedd.events.description',
      ),
      body: RowLayout(children: <Widget>[
        _getDate(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _getSocialItems(context),
        ),
        Separator.divider(),
        TextExpand(myEvent.description)
      ]),

    );
  }

  List<Widget> _getSocialItems(BuildContext context){
    var linkIcons = <Widget>[];
    if(myEvent.urlTwitter.isNotEmpty){
      linkIcons
          .add(Reusable.getLinkIcon("twitter", Colors.blue[300], myEvent.urlTwitter));
    }
    if(myEvent.urlFb.isNotEmpty){
      linkIcons
          .add(Reusable.getLinkIcon("facebook", Colors.blue[900], myEvent.urlFb));
    }
    return linkIcons;
  }

  _getDate() {
    return new Container(
      margin: new EdgeInsets.only(top: 4.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(DateFormat.yMMMd().format(myEvent.dateTime),
            style: new TextStyle(
                fontSize: 15.0,
                color: Colors.grey
            ),
          ),
        ],
      ),
    );
  }

  _getLocation(BuildContext context){
    return CardPage.body(
      title: FlutterI18n.translate(context, 'acuedd.events.location'),
      body: RowLayout(children: <Widget>[
        RowText(
          FlutterI18n.translate(context, 'acuedd.events.address'),
          myEvent.address,
        ),
        Separator.divider(),
        Image.asset("assets/images/venue.png"),
      ]),
    );
  }

  _getMoreInfo(BuildContext context){
    var listSpeaker = _generateSpeakerList();

    return Stack(
      children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(left: 40.0),
                child: RaisedButton.icon(
                  icon: Icon(Icons.schedule),
                  label: Text(FlutterI18n.translate(
                      context,
                      'acuedd.events.schedule')
                  ),
                  onPressed: (){

                  },
                ),
              ),
            ),
            if(listSpeaker.length > 0)
              Align(
                alignment: Alignment.centerRight,
                child:Container(
                  padding: EdgeInsets.only(right: 40.0),
                  child: RaisedButton.icon(
                    icon: Icon(Icons.person),
                    label: Text(FlutterI18n.translate(
                        context,
                        'acuedd.events.speakers')
                    ),
                    onPressed: (){
                      Navigator.of(context).push(FadeInRoute(
                          widget:Container(
                              child: DetailSpeakers(speakerList: listSpeaker,)
                          )
                      ));
                    },
                  ),
                ),
              )
      ],
    );
  }

  _generateSpeakerList(){
    List<SpeakerItem> _speakerList = [];

    _speakerList.add(SpeakerItem(TalkBoss(
        AugmentedSpeaker(
            id: "bojack",
            name: "BoJack Horseman",
            bio: "BoJack Horseman is a self-loathing 52-year-old alcoholic horse whose acting career peaked when he starred in a successful family sitcom called Horsin' Around in the late 1980s and later 'The Bojack Horseman Show' which was cancelled after one season, in 2007.\n\nThough he began as a young bright-eyed actor, he has since grown bitter, deeply depressed, and jaded towards Hollywood and who he has become post-fame. BoJack has been shown to be caring and insightful, but his insecurities, loneliness, and desperate need for approval often result in self-destructive actions that devastate those around him.\n\nMany of his issues stem from his childhood and issues with his unhappy parents, which the audience is shown through flashbacks.",
            imagePath: "http://jeff.mimic.ca/p/androidto/bojack.jpg",
            company: "Horsin' Around",
            twitter: "https://twitter.com/BoJackHorseman",
            github: "https://github.com/mimicmobile/flutter-conference-app"
        )
    )));

    _speakerList.add(SpeakerItem(TalkBoss(
        AugmentedSpeaker(
            id: "peanutbutter",
            name:  "Mr. Peanutbutter",
            bio: "asdklfjadklsjfkladsfjkladsjlfkadjslfajsdklfas",
            company: "aksdjfkl;adsjfkl;sadjlk;fdsajklfas",
            twitter: "",
            imagePath: "http://jeff.mimic.ca/p/androidto/mr_peanutbutter.jpg"
        )
    )));

    _speakerList.add(SpeakerItem(TalkBoss(
        AugmentedSpeaker(
            id: "3",
            name:  "Todd Chavez",
            bio: "asdklfjadklsjfkladsfjkladsjlfkadjslfajsdklfas",
            company: "aksdjfkl;adsjfkl;sadjlk;fdsajklfas",
            twitter: "",
            imagePath: "http://jeff.mimic.ca/p/androidto/todd.jpg"
        )
    )));

    _speakerList.add(SpeakerItem(TalkBoss(
        AugmentedSpeaker(
            id: "diane",
            name:  "Diane Nguyen",
            bio: "asdklfjadklsjfkladsfjkladsjlfkadjslfajsdklfas",
            company: "aksdjfkl;adsjfkl;sadjlk;fdsajklfas",
            twitter: "",
            imagePath: "http://jeff.mimic.ca/p/androidto/diane.jpg"
        )
    )));

    return _speakerList;
  }

}
