import 'package:church_of_christ/data/models/database.dart';
import 'package:church_of_christ/ui/pages/music_collection.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/gradient_back.dart';
import 'package:flutter/material.dart';

class MusicScreen extends StatefulWidget{
  const MusicScreen({
    Key key,
  }) : super(key:key);

  @override
  State createState() {
   return _MusicScreen();
  }
}

class _MusicScreen extends State<MusicScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: new musicCollection(),
        ),
      ),
    );
  }
}