
import 'dart:async';
import 'dart:io';
import 'package:church_of_christ/data/models/app_model.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/widgets/button_green.dart';
import 'package:church_of_christ/ui/widgets/card_image.dart';
import 'package:church_of_christ/ui/widgets/currency_dropdown.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:intl/intl.dart';

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
  final db = DbChurch();

  //Controllers
  final _textTitleController = TextEditingController();
  final _textDescriptionController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _textCostController = TextEditingController();
  final _textVideoController = TextEditingController();
  final _textURlFbController = TextEditingController();
  final _textURLTwitterController = TextEditingController();

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

  /*
  @override
  void dispose() {
    super.dispose();
    _textTitleController.dispose();
    _textDescriptionController.dispose();
    _textAddressController.dispose();
    _textCostController.dispose();
    _textVideoController.dispose();
    _textURlFbController.dispose();
    _textURLTwitterController.dispose();
  }*/

  void save(BuildContext context){
    final FormState form = _formKey.currentState;

    if(form.validate()){
      form.save();

      Scaffold
          .of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text(FlutterI18n.translate(context, 'acuedd.events.processing')),duration: Duration(minutes: 4),));

      print("eventediting");
      print(widget.eventEditing);
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
                const timeOut = const Duration(seconds: 4);
                new Timer(timeOut, (){
                  Navigator.pop(_scaffoldContext);
                });
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

  @override
  Widget build(BuildContext context) {
    if(widget.image == null && widget.eventEditing == null){
      Navigator.pop(context);
    }

    return _getBodyMyEvent(context);
  }
}
