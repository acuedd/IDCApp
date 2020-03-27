
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
               HeaderText(text:"Usuarios"
               ),
               ListCell.icon(
                 icon: Icons.person,
                 title: (user.status == Status.Authenticated)
                     ? user.user.displayName
                     : "Usuarios",
                 subtitle: (user.status == Status.Authenticated)
                     ? user.user.email
                     : "Inicia sesión o registrate con Google",
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
               HeaderText(text:"Iglesias"),
               ListCell.icon(
                 icon: Icons.location_on,
                 title: "Agrega una congregación",
                 subtitle: "Registrar tu congregación",
                 trailing: Icon(Icons.chevron_right),
                 onTap: ()=> showDialog(
                    context: context,
                      builder: (context) => RoundDialog(
                        title: "Iglesias",
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Próximamente"),
                          )
                        ],
                      ),
                    ),
               ),
               ListCell.icon(
                 icon: Icons.person_pin_circle,
                 title: "Expositores",
                 subtitle: "Ver a expositores de la iglesia",
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
               HeaderText(text: "Eventos"),
               ListCell.icon(
                 icon: Icons.event_available,
                 title: "Agrega un eventos",
                 subtitle:"Registra tu evento",
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
               HeaderText(text:"General"),
               ListCell.icon(
                 icon: Icons.palette,
                 title: "Apariencia",
                 subtitle: "Elige entre luz y oscuridad",
                 trailing: Icon(Icons.chevron_right),
                 onTap: () => showDialog(
                   context: context,
                   builder: (context) => RoundDialog(
                     title: "Apariencia",
                     children: <Widget>[
                       RadioCell<Themes>(
                         title: "Tema oscuro",
                         groupValue: _themeIndex,
                         value: Themes.dark,
                         onChanged: (value) => _changeTheme(value),
                       ),
                       RadioCell<Themes>(
                         title: "Tema negro",
                         groupValue: _themeIndex,
                         value: Themes.black,
                         onChanged: (value) => _changeTheme(value),
                       ),
                       RadioCell<Themes>(
                         title: "Monokai",
                         groupValue: _themeIndex,
                         value: Themes.monokai,
                         onChanged: (value) => _changeTheme(value),
                       ),
                       RadioCell<Themes>(
                         title: "Tema claro",
                         groupValue: _themeIndex,
                         value: Themes.light,
                         onChanged: (value) => _changeTheme(value),
                       ),
                       RadioCell<Themes>(
                         title: "Tema del sistema",
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
                 title: "Información",
                 subtitle: "Sobre la app",
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