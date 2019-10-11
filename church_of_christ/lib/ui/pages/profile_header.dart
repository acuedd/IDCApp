
import 'package:church_of_christ/data/models/app_model.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/user_info.dart';
import 'package:church_of_christ/ui/widgets/circle_button.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/gradient_back.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHeader extends StatefulWidget {
  @override
  _ProfileHeader createState() => _ProfileHeader();
}

class _ProfileHeader extends State<ProfileHeader> {
  final _formKey = GlobalKey<FormState>();
  bool _switchValue = false;
  double _kPickerSheetHeight = 216.0;
  DateTime date = DateTime.now();
  DateTime birth = DateTime.now();
  final dbUser = DbChurch();
  TextStyle style = TextStyle(fontFamily: 'Lato', fontSize: 15.0);
  String _dateBirth = "Not set";
  DateTime _dateBirthRaw ;
  String _dateBaptism = "Not set";
  DateTime _dateBaptismRaw;


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserRepository>(context);

    final ButtonsBar = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 10.0
      ),
      child: Row(
        children: <Widget>[
          //Cerrar Sesión
          CircleButton(
              false,
              Icons.exit_to_app, 40.0,
              Color.fromRGBO(255, 255, 255, 0.6),
              () => {
                Provider.of<UserRepository>(context).signOut()
              }
          ),
        ],
      ),
    );

    final String data = user.user.email;

    final codeQR = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 16,),
          QrImage(
            data: data,
            gapless: true,
            size: 250,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
          )
        ],
      ),
    );

    return BlanckPage(
        title: FlutterI18n.translate(context, 'app.profile'),
        actions: <Widget>[
          PopupSettins(context)
        ],
        body: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: ListView(children: <Widget>[
                StreamBuilder<User>(
                  stream: dbUser.streamUser(user.user.uid),
                  builder: (context, snapshot){
                    var myUser = snapshot.data;
                    if (myUser != null) {
                      _switchValue = myUser.baptized;
                      _dateBirthRaw = myUser.birthday;
                      _dateBirth ='${_dateBirthRaw.year}-${_dateBirthRaw.month.toString().padLeft(2,'0')}-${_dateBirthRaw.day.toString().padLeft(2,'0')}';
                      _dateBaptismRaw = myUser.baptismDate;
                      _dateBaptism ='${_dateBaptismRaw.year}-${_dateBaptismRaw.month.toString().padLeft(2,'0')}-${_dateBaptismRaw.day.toString().padLeft(2,'0')}';

                      return Container(
                        margin: EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            top: 0.0
                        ),
                        child: Column(
                          children: <Widget>[
                            UserInfo(),
                            _buildDatePicker(context, myUser),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                _buildMenu(
                                    <Widget>[
                                      Text(
                                          FlutterI18n.translate(context, 'acuedd.users.spiritual.baptized')
                                      ),
                                      CupertinoSwitch(
                                        value: _switchValue,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _switchValue = value;
                                            myUser.baptized = _switchValue;
                                            dbUser.updateBaptized(myUser);
                                          });
                                        },
                                      ),
                                    ]
                                ),
                              ],
                            ),
                            _buildDatePickerBirthday(context, myUser),
                            SizedBox(height: 16,),
                            SizedBox(height: 16,),
                            Stack(
                              children: <Widget>[
                                GradientBack(height: 275,colors: [
                                  Color(0xFFf0ffff),
                                  Color(0xFFe7ffba),
                                ],),
                                codeQR
                              ],
                            )
                          ],
                        ),
                      );
                    }
                    else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ]),
            )
        ),
      );


    /*

    * */
  }

  Widget PopupSettins(BuildContext myContext){
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "closeSession",
          child: Text('Cerrar sesión'),
        )
      ],
      onSelected: (text) async{
        print(text);
        if(text == "closeSession"){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('register_seen', null);
          prefs.setString(
            'register_date',
            null,
          );
          Provider.of<UserRepository>(myContext).signOut();
        }
      },
    );
  }

  Widget _buildMenu(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
          bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
        ),
      ),
      height: 44.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(FlutterI18n.translate(context, 'acuedd.users.spiritual.baptism_date'), style: TextStyle(
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
                    _dateBaptism = '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
                    _dateBaptismRaw = date;
                    setState(() {
                      date = _dateBaptismRaw;
                      user.baptismDate = date;
                      dbUser.updateBaptismDate(user);
                    });
                  }, currentTime: _dateBaptismRaw, locale: LocaleType.en);
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
                              (_dateBaptismRaw!=null)?DateFormat.yMMMMd().format(_dateBaptismRaw): '$_dateBaptism',
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
    );
  }

  Widget _buildDatePickerBirthday(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(FlutterI18n.translate(context, 'acuedd.users.spiritual.birthday'), style: TextStyle(
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
                    _dateBirth = '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
                    _dateBirthRaw = date;
                    setState(() {
                      birth = _dateBirthRaw;
                      user.birthday = birth;
                      dbUser.updateBirthday(user);
                    });
                  }, currentTime: _dateBirthRaw, locale: LocaleType.en);
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
                              (_dateBirthRaw!=null)?DateFormat.yMMMMd().format(_dateBirthRaw): '$_dateBirth',
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
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () { },
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }


}