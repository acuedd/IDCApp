

import 'dart:async';

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
import 'package:church_of_christ/util/functions.dart';
import 'package:church_of_christ/util/url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:row_collection/row_collection.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final EventModel myEvent;
  DetailPage({
    Key key,
    this.myEvent
  });

  @override
  State createState() {
    return _DetailPage();
  }


}


class _DetailPage extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  bool _haVideo;

  @override
  Widget build(BuildContext context) {
    _haVideo = (widget.myEvent.urlVideo.isEmpty)?false:true;

    return _getScaffoldSliverFab(context);
  }

  Widget _getScaffoldSliverFab(BuildContext context){
    return Scaffold(
      body: SliverFab(
        expandedHeight: MediaQuery.of(context).size.height * 0.3,
        floatingWidget: _haVideo
            ? FloatingActionButton(
                heroTag:  "btnVideo${widget.myEvent.title}",
                child: Icon(Icons.ondemand_video),
                tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.watch_replay'),
                onPressed: () async => await FlutterWebBrowser.openWebPage(
                  url: widget.myEvent.urlVideo,
                  androidToolbarColor: Theme.of(context).primaryColor,
                ),
              )
            : FloatingActionButton(
                heroTag: "btnCalendar${widget.myEvent.title}",
                child: Icon(Icons.event),
                backgroundColor: Theme.of(context).accentColor,
                tooltip: FlutterI18n.translate(context, 'acuedd.other.tooltip.add_event'),
                onPressed: () => Add2Calendar.addEvent2Cal(Event(
                  title: widget.myEvent.title,
                  description: widget.myEvent.description ??
                    FlutterI18n.translate(context, 'app.no_description'),
                  location: widget.myEvent.address,
                  startDate: widget.myEvent.dateTime,
                  endDate: widget.myEvent.dateTime.add(Duration(
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
    if(widget.myEvent.listImages == null)
      list = [widget.myEvent.urlImage];
    else
      list = widget.myEvent.listImages;

    return SliverBar(
      title: widget.myEvent.title,
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
        SharedContent(
          text: widget.myEvent.title,
          dateShow: DateFormat.yMMMd().add_jm().format(widget.myEvent.dateTime),
          myDetail: Url.shareDetails,),
        PopupSettins(),
      ],
    );
  }

  Widget _getPageBlanck(BuildContext context){
    return BlanckPage(
      title: widget.myEvent.title,//FlutterI18n.translate(context, 'Profile'),
      actions: <Widget>[
        SharedContent(text: widget.myEvent.title),
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
                  tag: widget.myEvent.title,
                  child: _getImageNetwork(Functions.getImgResizeUrl(widget.myEvent.urlImage,250,''))
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
        if(widget.myEvent.price > 0)
          _getPrice(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _getSocialItems(context),
        ),
        Separator.divider(),
        TextExpand(widget.myEvent.description)
      ]),

    );
  }

  List<Widget> _getSocialItems(BuildContext context){
    var linkIcons = <Widget>[];
    if(widget.myEvent.urlTwitter.isNotEmpty){
      linkIcons
          .add(Reusable.getLinkIcon("twitter", Colors.blue[300], widget.myEvent.urlTwitter));
    }
    if(widget.myEvent.urlFb.isNotEmpty){
      linkIcons
          .add(Reusable.getLinkIcon("facebook", Colors.blue[900], widget.myEvent.urlFb));
    }
    return linkIcons;
  }

  _getPrice(BuildContext context){
    return new Container(
      margin: new EdgeInsets.only(top: 4.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(FlutterI18n.translate(context, ('acuedd.events.tickets.cost'))+ " " + widget.myEvent.currency.toString() + " " + widget.myEvent.price.toString(),
            style: new TextStyle(
                fontSize: 15.0,
                color: Colors.grey
            ),)
        ],
      ),
    );
  }

  _getDate() {
    return new Container(
      margin: new EdgeInsets.only(top: 4.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(DateFormat.yMMMd().add_jm().format(widget.myEvent.dateTime),
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
          widget.myEvent.address,
        ),
        Separator.divider(),
        if(widget.myEvent.longitude != 0.0 && widget.myEvent.latitude != 0.0)
          _getMapPoint(),

        if(widget.myEvent.longitude != 0.0 && widget.myEvent.latitude != 0.0)
          _getButtonToMaps(),
      ]),
    );

    /*return Row(
      children: <Widget>[
        if(myEvent.longitude != 0.0 && myEvent.latitude != 0.0)
          _getMapPoint(),
    ]);*/

  }

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  _getMapPoint(){
    return Row(
      children: <Widget>[
        Expanded(
        flex: 10,
        child:
          Container(
            height: 200,
            child: GoogleMap(
              onTap: (LatLng pos){
                print("TAP");
                print(pos);
                FlutterWebBrowser.openWebPage(
                  url: "google.navigation:q=${widget.myEvent.latitude},${widget.myEvent.longitude}",
                  androidToolbarColor: Theme.of(context).primaryColor,
                );
              },
              mapType: MapType.satellite,
              myLocationEnabled: false,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;

                LatLng position = LatLng(widget.myEvent.latitude, widget.myEvent.longitude);
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: position,
                      zoom: 16.4746,
                    )
                ));
                _addMarker(position);
              },
              compassEnabled: true,
              markers: Set<Marker>.of(markers.values),
              gestureRecognizers:
              <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                ),
              ].toSet(),
            ),
        ),
      ),
    ]);
  }

  void _addMarker(LatLng pos){
    final String markerIdVal = 'marker_id_0';
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: pos,
    );

    setState(() {
      //List<String> latlng = this.location.toString().trim().replaceAll('SRID=4326;POINT (', '').replaceAll(')', '').split(' ');
      //location = "SRID=4326;POINT (" + pos.longitude.toString() + " " + pos.latitude.toString() + ")";
      markers[markerId] = marker;
    });
  }

  _getButtonToMaps(){
    return RaisedButton.icon(
      icon: Icon(Icons.location_on),
      onPressed: () async => await FlutterWebBrowser.openWebPage(
        url: "google.navigation:q=${widget.myEvent.latitude},${widget.myEvent.longitude}",
        androidToolbarColor: Theme.of(context).primaryColor,
      ),
      label: Text(FlutterI18n.translate(context, 'acuedd.events.basics.openMaps')),
    );
  }

  _getMoreInfo(BuildContext context){

    return Stack(
      children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(left: 30.0),
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
            if(widget.myEvent.spearkers.length > 0)
              Align(
                alignment: Alignment.centerRight,
                child:Container(
                  padding: EdgeInsets.only(right: 30.0),
                  child: RaisedButton.icon(
                    icon: Icon(Icons.person),
                    label: Text(FlutterI18n.translate(
                        context,
                        'acuedd.events.speakers')
                    ),
                    onPressed: (){
                      Navigator.of(context).push(FadeInRoute(
                          widget:Container(
                              child: DetailSpeakers(eventModel: widget.myEvent,)
                          )
                      ));
                    },
                  ),
                ),
              )
      ],
    );
  }

}
