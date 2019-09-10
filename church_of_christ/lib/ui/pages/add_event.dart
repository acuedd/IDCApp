
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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  User user;
  File image;

  AddEventScreen({
    Key key,
    this.user,
    this.image,
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

  }


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
  }

  void save(){
    final FormState form = _formKey.currentState;

    if(form.validate()){
      form.save();

      Scaffold
          .of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text('Processing Data')));

      final stringDate = "${_date} ${_time}";
      String path = "${widget.user.uid}/${DateTime.now().toString()}.jpg";

      db.uploadFile(path, widget.image)
          .then((StorageUploadTask storageUploadTask){
            print(storageUploadTask);
            storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
              snapshot.ref.getDownloadURL().then((urlImage){
                print("URLIMAGE: ${urlImage}");
                String stringDateFilter = stringDate.replaceAll(RegExp(' +'), ' ');
                print(stringDate);
                var mydate = DateTime.parse(stringDateFilter);
                print(mydate);

                final EventModel model = new EventModel(
                  id: null,
                  title: _textTitleController.text,
                  urlImage: urlImage,
                  dateTime: DateTime.parse(stringDate),
                  description: _textDescriptionController.text,
                  currency: currencyValue,
                  price: double.parse(_textCostController.text),
                  address: _textAddressController.text,
                  urlVideo: _textVideoController.text,
                  urlFb: _textURlFbController.text,
                  urlTwitter: _textURLTwitterController.text,
                );

                db.updateEvent(model).whenComplete((){
                  print("GUARDO EL EVENTO");
                  Scaffold
                      .of(_scaffoldContext)
                      .showSnackBar(SnackBar(content: Text('Se ha guardado la información del evento.')));
                });

              });
            }).catchError((error){
              print("ERROR\n");
              print(error);
            });
      });
    }
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
                save();
              },
              child: Text("Save"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
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
                          imageFile: widget.image,//"assets/img/sunset.jpeg",
                          iconData: Icons.camera_alt,
                          width: 350.0,
                          height: 250.0,left: 0,
                          internet: false,
                        ),
                      ), //Foto
                      Separator.divider(indent: 72),
                      HeaderText(text: "Basicos"),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _textTitleController,
                          style: style,
                          decoration: InputDecoration(
                            labelText: "Nombre del evento",
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _textDescriptionController,
                          maxLines: 4,
                          style: style,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: "Descripcion",
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _textAddressController,
                          maxLines: 1,
                          style: style,
                          decoration: InputDecoration(
                            labelText: "Dirección",
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
                            Text('Fecha del evento', style: TextStyle(
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
                                    }, currentTime: DateTime.now(), locale: LocaleType.en);
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
                            Text('Hora inicio', style: TextStyle(
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
                                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                                setState(() {});
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
                      HeaderText(text: "Entradas (opcional)"),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Moneda'),
                            CurrencyDropDown(currencyValue: currencyValue, onChanged: _onCurrencyChanged),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _textCostController,
                          maxLines: 1,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          style: style,
                          decoration: InputDecoration(
                            labelText: "Costo de entradas",
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      HeaderText(text: "Social Media"),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _textVideoController,
                          maxLines: 1,
                          style: style,
                          decoration: InputDecoration(
                            labelText: "Url de video",
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
                            labelText: "Url facebook",
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
                            labelText: "Url twiter",
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
    return _getBodyMyEvent(context);
  }
}
