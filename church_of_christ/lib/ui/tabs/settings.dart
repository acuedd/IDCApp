
import 'package:church_of_christ/data/models/app_model.dart';
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/settings.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/add_event.dart';
import 'package:church_of_christ/ui/pages/my_events.dart';
import 'package:church_of_christ/ui/pages/show_speakers.dart';
import 'package:church_of_christ/ui/screens/sign_in_screen.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/dialog_round.dart';
import 'package:church_of_christ/ui/widgets/fade_in_route.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/list_cell.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/radio_cell.dart';
import 'package:church_of_christ/ui/widgets/sliver_bar.dart';
import 'package:church_of_christ/util/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget{
  const SettingsScreen({
    Key key,
  }) : super(key:key);

  @override
  State createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen>{

  Themes _themeIndex;
  final dbUser = DbChurch();
  User userLogged;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async{
      _themeIndex = Provider.of<AppModel>(context).theme;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _handleConsumeSettings(context);
  }

  Widget _handleConsumeSettings(BuildContext context){
    final user = Provider.of<UserRepository>(context);
    //print(user.status);
    if(user.status == Status.Authenticated){
      dbUser.getUser(user.user.uid).then((User user){
        setState(() {
          userLogged = user;
        });
      });
    }
    else {
      userLogged = null;
    }

    return Scaffold(
      body: SafeArea( child: Consumer<AppModel>(
        builder: (context, model, child) => Container(
          child: ListView(
             children: <Widget>[
               HeaderText(text:FlutterI18n.translate(
                 context,
                 'acuedd.users.title',
               )
               ),
               ListCell.icon(
                 icon: Icons.person,
                 title: (user.status == Status.Authenticated)
                     ? user.user.displayName
                     : FlutterI18n.translate(context, 'acuedd.users.title'),
                 subtitle: (user.status == Status.Authenticated)
                     ? user.user.email
                     : FlutterI18n.translate(context, 'acuedd.users.icon'),
                 trailing: Icon(Icons.chevron_right),
                 onTap:(){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => ChangeNotifierProvider.value(
                           value: UserRepository.instance(),
                           child: SignInScreen(),
                         ),
                       )
                   );
                 },
               ),
               Separator.divider(indent: 72),
               HeaderText(text:FlutterI18n.translate(
                 context,
                 'acuedd.churchs.title',
               )),
               ListCell.icon(
                 icon: Icons.location_on,
                 title: FlutterI18n.translate(context, 'acuedd.churchs.add.title'),
                 subtitle: FlutterI18n.translate(context, 'acuedd.churchs.add.subtitle'),
                 trailing: Icon(Icons.chevron_right),
                 onTap:(){

                 },
               ),
               ListCell.icon(
                 icon: Icons.person_pin_circle,
                 title: FlutterI18n.translate(context, 'acuedd.speakers.title'), 
                 subtitle: FlutterI18n.translate(context, 'acuedd.speakers.subtitle'),
                 trailing: Icon(Icons.chevron_right),
                 onTap: (){
                   Navigator.of(context).push(
                     MaterialPageRoute(
                      builder: (context) => ShowSpeakers(userLogged),
                    )
                  );
                 },
               ),
               Separator.divider(indent: 72),
               HeaderText(text: FlutterI18n.translate(
                   context,
                   'acuedd.events.title'
               )),
               ListCell.icon(
                 icon: Icons.event_available,
                 title: FlutterI18n.translate(context, 'acuedd.events.add.title'),
                 subtitle: FlutterI18n.translate(context, 'acuedd.events.add.subtitle'),
                 trailing: Icon(Icons.chevron_right),
                 onTap:(){
                   if(user.status == Status.Authenticated){
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => MyEventScreen(myUser: userLogged)
                       ),
                     );
                   }
                   else{
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => ChangeNotifierProvider.value(
                             value: UserRepository.instance(),
                             child: SignInScreen(),
                           ),
                         )
                     );
                   }
                 },
               ),
               Separator.divider(indent: 72),
               HeaderText(text:FlutterI18n.translate(
                 context,
                 'settings.headers.general',
               )),
               ListCell.icon(
                 icon: Icons.palette,
                 title: FlutterI18n.translate(context, 'settings.theme.title'),
                 subtitle: FlutterI18n.translate(context, 'settings.theme.body'),
                 trailing: Icon(Icons.chevron_right),
                 onTap: () => showDialog(
                   context: context,
                   builder: (context) => RoundDialog(
                     title: FlutterI18n.translate(
                       context,
                       'settings.theme.title',
                     ),
                     children: <Widget>[
                       RadioCell<Themes>(
                         title: FlutterI18n.translate(
                           context,
                           'settings.theme.theme.dark',
                         ),
                         groupValue: _themeIndex,
                         value: Themes.dark,
                         onChanged: (value) => _changeTheme(value),
                       ),
                       RadioCell<Themes>(
                         title: FlutterI18n.translate(
                           context,
                           'settings.theme.theme.black',
                         ),
                         groupValue: _themeIndex,
                         value: Themes.black,
                         onChanged: (value) => _changeTheme(value),
                       ),
                       RadioCell<Themes>(
                         title: FlutterI18n.translate(
                           context,
                           'settings.theme.theme.light',
                         ),
                         groupValue: _themeIndex,
                         value: Themes.light,
                         onChanged: (value) => _changeTheme(value),
                       ),
                       RadioCell<Themes>(
                         title: FlutterI18n.translate(
                           context,
                           'settings.theme.theme.system',
                         ),
                         groupValue: _themeIndex,
                         value: Themes.system,
                         onChanged: (value) => _changeTheme(value),
                       ),
                     ],
                   ),
                 ),
               ),
               ListCell.icon(
                 icon: Icons.info,
                 title: FlutterI18n.translate(context, 'app.menu.about'),
                 subtitle: FlutterI18n.translate(context, 'about.headers.about'),
                 trailing: Icon(Icons.chevron_right),
                 onTap: (){
                   Navigator.pushNamed(context, '/about');
                 },
               )
             ],
           ),
        ),
      ),
    )
    );
  }


  void _changeTheme(Themes theme) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    Provider.of<AppModel>(context).theme = theme;
    prefs.setInt('theme', theme.index);

    // Updates UI
    setState(() => _themeIndex = theme);

    // Hides dialog
    Navigator.of(context).pop();
  }
}