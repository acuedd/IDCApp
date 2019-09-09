

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:share/share.dart';

class SharedContent extends StatelessWidget{

  final String text;
  SharedContent({
    Key key,
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () => Share.share(
        text
      ),
      tooltip: FlutterI18n.translate(
          context,
          'acuedd.other.menu.share'
      ),
    );
  }
}