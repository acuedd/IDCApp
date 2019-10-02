
import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/gradient_back.dart';
import 'package:flutter/material.dart';

class ChurchScreen extends StatefulWidget{

  const ChurchScreen({
    Key key,
  }) : super(key:key);

  @override
  State createState() {
    return _ChurchScreen();
  }
}

class _ChurchScreen extends State<ChurchScreen>{
  double screenWidht;

  @override
  Widget build(BuildContext context) {
    var db = DbChurch();
    BuildContext _scaffoldContext;

    screenWidht = MediaQuery.of(context).size.width;
    return BlanckPage(
      title: "Iglesias",
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GradientBack(height: null),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 50.0,
                      right: 50.0,
                    ),
                    width: screenWidht,
                    child: Text("Muy pronto! el directorio de iglesias",
                      style: TextStyle(
                          fontSize: 37.0,
                          fontFamily: "Lato",
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
        ])
      ]),
    );
  }
}