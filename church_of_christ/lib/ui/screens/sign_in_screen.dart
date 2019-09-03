

import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/login_page.dart';
import 'package:church_of_christ/ui/pages/profile_header.dart';
import 'package:church_of_christ/ui/widgets/button_green.dart';
import 'package:church_of_christ/ui/widgets/gradient_back.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget{

  @override
  State createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen>{
  double screenWidht;


  @override
  Widget build(BuildContext context) {
    screenWidht = MediaQuery.of(context).size.width;
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession(){
    return Consumer(
      builder: (context, UserRepository user, _) {
        switch (user.status){

          case Status.Uninitialized:
            return Splash();
            break;
          case Status.Unauthenticated:
          case Status.Authenticating:
            return LoginPage();
            break;
          case Status.Authenticated:
            return ProfileHeader();
            break;
        }
      }
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}