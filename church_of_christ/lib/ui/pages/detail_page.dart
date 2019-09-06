

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:church_of_christ/ui/widgets/cache_image.dart';
import 'package:church_of_christ/ui/widgets/card_page.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/expand_widget.dart';
import 'package:church_of_christ/ui/widgets/header_swiper.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/row_item.dart';
import 'package:church_of_christ/ui/widgets/shared_item.dart';
import 'package:church_of_christ/ui/widgets/sliver_bar.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:row_collection/row_collection.dart';
import 'package:sliver_fab/sliver_fab.dart';

class DetailPage extends StatelessWidget{

  final _formKey = GlobalKey<FormState>();

  final _img;
  final _title;
  final _date;
  final _description;
  final _link;
  final _category;
  final _origin;
  bool _hasVideo = true;
  String _getVideo = "";


  DetailPage(this._img,this._title,this._date,this._description,this._category,this._link,this._origin);

  @override
  Widget build(BuildContext context) {

    return _getScaffoldSliverFab(context);
  }

  Widget _getScaffoldSliverFab(BuildContext context){
    return Scaffold(
      body: SliverFab(
        expandedHeight: MediaQuery.of(context).size.height * 0.3,
        floatingWidget: _hasVideo
            ? FloatingActionButton(
                heroTag:  null,
                child: Icon(Icons.ondemand_video),
                tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.watch_replay'),
                onPressed: () async => await FlutterWebBrowser.openWebPage(
                  url: _getVideo,
                  androidToolbarColor: Theme.of(context).primaryColor,
                ),
              )
            : FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.event),
                backgroundColor: Theme.of(context).accentColor,
                tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.add_event'),
                onPressed: () => Add2Calendar.addEvent2Cal(Event(
                  title: _title,
                  description: _description ?? 
                    FlutterI18n.translate(context, 'app.no_description'),
                  location: _origin,
                  startDate: _date,
                  endDate: _date
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
        ])
    );
  }

  Widget _getSliverBar(BuildContext context){
    final List<String> list = [_img];
    return SliverBar(
      title: _title,
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
      title: _title,//FlutterI18n.translate(context, 'Profile'),
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
                  tag: _title,
                  child: _getImageNetwork(Functions.getImgResizeUrl(_img,250,''))
              ),
              _getDescription(context),
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
        'app.description',
      ),
      body: RowLayout(children: <Widget>[
        RowText(
          FlutterI18n.translate(
            context,
            'acuedd.events.search.date',
          ),
          _date,
        ),
        Separator.divider(),
        TextExpand(_description)
      ]),
    );
  }
}
