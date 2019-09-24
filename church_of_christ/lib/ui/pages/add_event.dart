
import 'dart:async';
import 'dart:io';
import 'package:church_of_christ/data/models/app_model.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/pages/add_event_speaker.dart';
import 'package:church_of_christ/ui/widgets/card_image.dart';
import 'package:church_of_christ/ui/widgets/currency_dropdown.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:intl/intl.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as  prefix0;


const kGoogleApiKey = "AIzaSyCrPp6dS9aSEHKqnV29a_xNwu78owrt0tU";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddEventScreen extends StatefulWidget {
  User user;
  File image;
  EventModel eventEditing;

  AddEventScreen({
    Key key,
    this.user,
    this.image,
    this.eventEditing,
  });

  @override
  State createState() {
    return _AddEventScreen();
  }
}

class _AddEventScreen extends State<AddEventScreen> {

  TextStyle style = TextStyle(fontFamily: 'Lato', fontSize: 15.0);

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String currencyValue = 'GTQ';
  String currencySymbol = '';
  String _date = "Not set";
  String _time = "Not set";
  DateTime _dateRaw ;
  DateTime _timeRaw ;
  BuildContext _scaffoldContext;
  prefix0.Location location = new prefix0.Location();
  LatLng locationToSave;

  final db = DbChurch();

  //Controllers
  final _textTitleController = TextEditingController();
  final _textDescriptionController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _textCostController = TextEditingController();
  final _textVideoController = TextEditingController();
  final _textURlFbController = TextEditingController();
  final _textURLTwitterController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  _onCurrencyChanged(val, symbol) {
    setState(() {
      currencyValue = val;
      currencySymbol = symbol;
    });
  }

  @override
  void initState() {
    super.initState();

    if(widget.eventEditing != null){
      _textTitleController.text = widget.eventEditing.title;
      _textDescriptionController.text = widget.eventEditing.description;
      _textAddressController.text = widget.eventEditing.address;
      _textCostController.text = widget.eventEditing.price.toString();
      _textVideoController.text = widget.eventEditing.urlVideo;
      _textURlFbController.text = widget.eventEditing.urlFb;
      _textURLTwitterController.text = widget.eventEditing.urlTwitter;
      currencyValue = widget.eventEditing.currency;
      _dateRaw = widget.eventEditing.dateTime;
      _timeRaw = widget.eventEditing.dateTime;
      _date = '${_dateRaw.year}-${_dateRaw.month.toString().padLeft(2,'0')}-${_dateRaw.day.toString().padLeft(2,'0')}';
      _time = '${_timeRaw.hour.toString().padLeft(2,'0')}:${_timeRaw.minute.toString().padLeft(2,'0')}:${_timeRaw.second.toString().padLeft(2,'0')}';
    }
  }

  void save(BuildContext context){
    final FormState form = _formKey.currentState;

    if(form.validate()){
      form.save();

      Scaffold
          .of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text(FlutterI18n.translate(context, 'acuedd.events.processing')),duration: Duration(minutes: 4),));

      if(widget.eventEditing != null){
        final stringDate = "${_date} ${_time}";

        db.updateEvent(EventModel(
          id: widget.eventEditing.id,
          title: _textTitleController.text,
          //urlImage: urlImage,
          dateTime: DateTime.parse(stringDate),
          description: _textDescriptionController.text,
          currency: currencyValue,
          price: (_textCostController.text.isEmpty)?0:double.parse(_textCostController.text),
          address: _textAddressController.text,
          urlVideo: _textVideoController.text,
          urlFb: _textURlFbController.text,
          urlTwitter: _textURLTwitterController.text,
          longitude: (locationToSave != null)?locationToSave.longitude:0,
          latitude: (locationToSave != null)?locationToSave.latitude:0,
        ));

        print("UPDATE EL EVENTO");
        Scaffold.of(_scaffoldContext).removeCurrentSnackBar();
        Scaffold
            .of(_scaffoldContext)
            .showSnackBar(SnackBar(content: Text(FlutterI18n.translate(context, 'acuedd.events.updatedata'))));
      }
      else{
        final stringDate = "${_date} ${_time}";
        String path = "${widget.user.uid}/${DateTime.now().toString()}.jpg";
        bool boolLoading = true;
        db.uploadFile(path, widget.image)
            .then((StorageUploadTask storageUploadTask){
          //print(storageUploadTask);
          storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
            snapshot.ref.getDownloadURL().then((urlImage){
              print("URLIMAGE: ${urlImage}");
              String stringDateFilter = stringDate.replaceAll(RegExp(' +'), ' ');
              print(stringDate);

              final EventModel model = new EventModel(
                id: null,
                title: _textTitleController.text,
                urlImage: urlImage,
                dateTime: DateTime.parse(stringDate),
                description: _textDescriptionController.text,
                currency: currencyValue,
                price: (_textCostController.text.isEmpty)?0:double.parse(_textCostController.text),
                address: _textAddressController.text,
                urlVideo: _textVideoController.text,
                urlFb: _textURlFbController.text,
                urlTwitter: _textURLTwitterController.text,
                location: (locationToSave != null)?locationToSave:null,
                longitude: (locationToSave != null)?locationToSave.longitude:0,
                latitude: (locationToSave != null)?locationToSave.latitude:0,
              );

              db.addEvent(model).whenComplete((){
                print("GUARDO EL EVENTO");
                Scaffold.of(_scaffoldContext).removeCurrentSnackBar();
                Scaffold
                    .of(_scaffoldContext)
                    .showSnackBar(
                    SnackBar(
                      content: Text(FlutterI18n.translate(context, 'acuedd.events.saveData')),
                    )
                );
                Navigator.pop(_scaffoldContext);
              });

            });
          }).catchError((error){
            print("ERROR\n");
            print(error);
          });
        });

      }
    }
  }

  void delete(){
    db.deleteEvent(widget.eventEditing);
    Navigator.pop(_scaffoldContext);
  }

  Widget _getBodyMyEvent(BuildContext content){

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            FlutterI18n.translate(context, 'acuedd.events.add.subtitle'),
            style: TextStyle(fontFamily: 'Lato'),
          ),
          centerTitle: false,
          actions: <Widget>[
            //PopupSettins()
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                save(content);
              },
              child: Text(FlutterI18n.translate(content, 'app.save')),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
            if(widget.eventEditing != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  delete();
                },
              ),
          ],
        ),
        body: new Builder(
          builder: (BuildContext context){
            _scaffoldContext = context;
            return Form(
              key: _formKey,
              child: Center(
                child: ListView(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: CardImageWithFabIcon(
                              imageFile: (widget.eventEditing != null)?widget.eventEditing.urlImage :widget.image,//"assets/img/sunset.jpeg",
                              iconData: Icons.camera_alt,
                              width: 350.0,
                              height: 250.0,left: 0,
                              internet: (widget.eventEditing != null)?true:false,
                            ),
                      ), //Foto
                      Separator.divider(indent: 72),

                      if(widget.eventEditing != null)
                        _getButtonsAddInfo(context),

                      Separator.divider(indent: 72),
                      HeaderText(text: FlutterI18n.translate(context, 'acuedd.events.basics.title')),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _textTitleController,
                          style: style,
                          decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, 'acuedd.events.basics.name'),
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _textDescriptionController,
                          maxLines: 4,
                          style: style,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, 'acuedd.events.basics.description'),
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          //mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(FlutterI18n.translate(context, 'acuedd.events.basics.date'), style: TextStyle(
                                color: Colors.grey
                            ),),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 1.0,
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    theme: DatePickerTheme(
                                      containerHeight: 210.0,
                                    ),
                                    showTitleActions: true,
                                    minTime: DateTime(2000, 1, 1),
                                    maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                                      print('confirm $date');
                                      print(date.runtimeType);
                                      _date = '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
                                      _dateRaw = date;
                                      setState(() {});
                                    }, currentTime: _dateRaw, locale: LocaleType.en);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 18.0,
                                                //color: Colors.teal,
                                              ),
                                              Text(
                                                  (_dateRaw!=null)?DateFormat.yMMMMd().format(_dateRaw): '$_date',
                                                style: style,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "  Change",
                                      style: style,
                                    ),
                                  ],
                                ),
                              ),
                              color: (Provider.of<AppModel>(context).theme == Themes.black)? Theme.of(context).cardColor : Theme.of(context).cardColor,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(FlutterI18n.translate(context, 'acuedd.events.basics.time'), style: TextStyle(
                                color: Colors.grey
                            ),),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 1.0,
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    theme: DatePickerTheme(
                                      containerHeight: 210.0,
                                    ),
                                    showTitleActions: true, onConfirm: (time) {
                                      print('confirm $time');
                                      print(time.runtimeType);
                                      _time = '${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}:${time.second.toString().padLeft(2,'0')}';
                                      _timeRaw = time;
                                      setState(() {});
                                    }, currentTime: _timeRaw, locale: LocaleType.en);
                                setState(() {

                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.access_time,
                                                size: 18.0,
                                                //color: Colors.teal,
                                              ),
                                              Text(
                                                " $_time",
                                                style: style,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "  Change",
                                      style: style,
                                    ),
                                  ],
                                ),
                              ),
                              color: (Provider.of<AppModel>(context).theme == Themes.black)? Theme.of(context).cardColor : Theme.of(context).cardColor,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _textAddressController,
                          maxLines: 1,
                          style: style,
                          decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, 'acuedd.events.address'),
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      if(widget.eventEditing != null)
                        _getSearchLocation(),
                      if(widget.eventEditing != null)
                        _getMyLocation(context),
                      Separator.divider(indent: 72),
                      HeaderText(text: FlutterI18n.translate(context, 'acuedd.events.tickets.name')),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(FlutterI18n.translate(context, 'acuedd.events.tickets.currency')),
                            CurrencyDropDown(currencyValue: currencyValue, onChanged: _onCurrencyChanged),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _textCostController,
                          maxLines: 1,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          style: style,
                          decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, 'acuedd.events.tickets.cost'),
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      HeaderText(text: FlutterI18n.translate(context, 'acuedd.events.socialMedia.name')  ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _textVideoController,
                          maxLines: 1,
                          style: style,
                          decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, 'acuedd.events.socialMedia.urlVideo'),
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _textURlFbController,
                          maxLines: 1,
                          style: style,
                          decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, 'acuedd.events.socialMedia.facebook'),
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _textURLTwitterController,
                          maxLines: 1,
                          style: style,
                          decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, 'acuedd.events.socialMedia.twitter'),
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                    ]),
              ),
            );
          },
        ),


    );
  }

  _getSearchLocation(){
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 15, bottom: 15),
          child: RaisedButton.icon(
            onPressed: _handlePressButton,
            label: Text("Buscar lugar"),
            icon: Icon(Icons.search),
          ),
        )
      ],
    );
  }

  _getMyLocation(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
            flex: 10,
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 300,
              child: GoogleMap(
                onTap: (LatLng pos) {
                  _addMarker(pos);
                },
                mapType: MapType.normal,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapController = controller;
                  if(widget.eventEditing.longitude != null && widget.eventEditing.latitude != null
                      || widget.eventEditing.longitude > 0 && widget.eventEditing.latitude > 0){
                    _animateLocation();
                  }
                  else{
                    _animateMyLocation();
                  }
                },
                markers: Set<Marker>.of(markers.values),
                gestureRecognizers:
                <Factory<OneSequenceGestureRecognizer>>[
                  Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                  ),
                ].toSet(),
              ),
            )
        )
      ],
    );
  }

  _getButtonsAddInfo(BuildContext context){
    return RowLayout.cards(children: <Widget>[
      SizedBox(height: 10.0,),
      Stack(children: <Widget>[
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
                  Navigator.of(_scaffoldContext).push(FadeRoute(AssignSpeakerEvent(user: widget.user, eventModel: widget.eventEditing,)));
                },
              ),
            ),
          ),
      ]),
      SizedBox(height: 10.0,),
    ]);
  }

  _animateMyLocation() async{
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 14.4746,
        )
    ));
  }

  _animateLocation()async{
    LatLng position = LatLng(widget.eventEditing.latitude, widget.eventEditing.longitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: 16.4746,
      )
    ));

    _addMarker(position);
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
      locationToSave = pos;
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async{
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.fullscreen,
      language: "es",
      hint: 'Buscar',
    );

    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      _addMarker(LatLng(lat, lng));
      setState(() {
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 270.0,
              target: LatLng(lat, lng),
              tilt: 30.0,
              zoom: 17.0,
            ),
          ),
        );
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    if(widget.image == null && widget.eventEditing == null){
      Navigator.pop(context);
    }

    return _getBodyMyEvent(context);
  }
}
