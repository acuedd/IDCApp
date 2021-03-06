import 'package:church_of_christ/church_of_christ.dart';
import 'package:church_of_christ/ui/screens/about.dart';
import 'package:church_of_christ/ui/screens/sign_in_screen.dart';
import 'package:church_of_christ/ui/screens/start.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/app_model.dart';

/// Main app model
final AppModel model = AppModel();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await model.init();
  runApp(CherryApp());
}

class CherryApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>(
      create: (context) => model,
      child: Consumer<AppModel>(
        builder: (context, model, child) => MaterialApp(
          title: "Iglesia de Cristo Rom. 16:16",
          theme: model.requestTheme(Brightness.light),
          darkTheme: model.requestTheme(Brightness.dark),
          home: StartScreen(),
          debugShowCheckedModeBanner: false,
          routes: <String, WidgetBuilder>{
            '/about': (_)=> AboutScreen(),
            '/user': (_) => SignInScreen(),
          },
        ),
      ),
    );
  }
}

