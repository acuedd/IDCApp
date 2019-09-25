

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
        FlutterI18n.translate(
          context,
          'acuedd.other.share.body',
          {
            'name': "${text}",
            'date': "${dateShow}",
            'detail': "${myDetail}",
          }
      )),
      tooltip: FlutterI18n.translate(
        context,
        'spacex.other.menu.share',
      ),
    );
  }
}