
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/user_info.dart';
import 'package:church_of_christ/ui/widgets/circle_button.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/gradient_back.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

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
  final dbUser = UserDB();

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
        title: FlutterI18n.translate(context, 'Profile'),
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
                      print(myUser.baptismDate);
                      _switchValue = myUser.baptized;
                      date = myUser.baptismDate;
                      birth = myUser.birthday;

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
                      return CircularProgressIndicator();
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
      onSelected: (text){
        print(text);
        if(text == "closeSession"){
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
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
              CupertinoDatePicker(
                //backgroundColor: isDarkModeEnabled ? Colors.black : Colors.white,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: date,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState((){
                    date = newDateTime;
                    user.baptismDate = date;
                    dbUser.updateBaptismDate(user);
                  });
                },
              ),
            );
          },
        );
      },
      child: _buildMenu(
          <Widget>[
            Text(
                FlutterI18n.translate(context, 'acuedd.users.spiritual.baptism_date')
            ),
            Text(
              DateFormat.yMMMMd().format(date),
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
          ]
      ),
    );
  }

  Widget _buildDatePickerBirthday(BuildContext context, User user) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
              CupertinoDatePicker(
                //backgroundColor: isDarkModeEnabled ? Colors.black : Colors.white,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: birth,
                onDateTimeChanged: (DateTime newDateTime2) {
                  setState((){
                    birth = newDateTime2;
                    user.birthday = birth;
                    dbUser.updateBirthday(user);
                  });
                },
              ),
            );
          },
        );
      },
      child: _buildMenu(
          <Widget>[
            Text(
              FlutterI18n.translate(context, 'acuedd.users.spiritual.birthday')
            ),
            Text(
              DateFormat.yMMMMd().format(birth),
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
          ]
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