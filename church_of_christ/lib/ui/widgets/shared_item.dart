

import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SharedContent extends StatelessWidget{

  final String text;
  final String dateShow;
  final String myDetail;
  SharedContent({
    Key key,
    @required this.text,
    this.dateShow,
    this.myDetail
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () => Share.share(
        "La Iglesia de Cristo {name} el {date}, Tu asistencia será de bendición {detail}"),
      tooltip: "Compartir",
    );
  }
}