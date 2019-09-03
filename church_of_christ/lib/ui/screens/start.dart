

import 'package:church_of_christ/data/models/settings.dart';
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/tabs/settings.dart';
import 'package:church_of_christ/ui/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class StartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Reading app shortcuts input
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((type){
      switch (type){
        case 'home':
          setState( ()=> _currentIndex = 1);
          break;
        case 'events':
          setState( ()=> _currentIndex = 2);
          break;
        case 'settings':
          setState( ()=> _currentIndex = 3);
          break;
        default:
          setState( ()=> _currentIndex = 0);
      }
    });

    Future.delayed(Duration.zero, () async {
      //Settings app shortcuts
      quickActions.setShortcutItems(<ShortcutItem>[
        ShortcutItem(
          type: 'events',
          localizedTitle: FlutterI18n.translate(
              context,
              'acuedd.events.icon'
          ),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<SingleChildCloneableWidget> _models = [
      ChangeNotifierProvider(
        builder: (context) => UserRepository.instance(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "events",
              style: TextStyle(fontFamily: 'Lato'),
            ),
          ),
          body: Container(child: Text("Eventos we"),),
        ),
      ),
      ChangeNotifierProvider(
        builder: (context)=> UserRepository.instance(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "holi",
              style: TextStyle(fontFamily: 'Lato'),
            ),
          ),
          body: Container(child: Text("hola"),),
        ),
      ),
      ChangeNotifierProvider(
        builder: (context) => SettingsModel(),
        child: SettingsScreen(),
      )
    ];

    return MultiProvider(
      providers: _models,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _models),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: TextStyle(fontFamily: 'Lato'),
          unselectedLabelStyle: TextStyle(fontFamily: 'Lato'),
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState( ()=> _currentIndex = index),
          currentIndex: _currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text(FlutterI18n.translate(
                context,
                'acuedd.events.icon',
              )),
              icon: Icon(Icons.event),
            ),
            BottomNavigationBarItem(
              title: Text(FlutterI18n.translate(
                context,
                'acuedd.churchs.icon',
              )),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              title: Text(FlutterI18n.translate(
                context,
                'settings.headers.general',
              )),
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}