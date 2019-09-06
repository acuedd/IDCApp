

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SharedContent extends StatelessWidget{
  final VoidCallback onPressedFabIcon;

  SharedContent({
    Key key,
    @required this.onPressedFabIcon
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () => onPressedFabIcon,
      tooltip: FlutterI18n.translate(
          context,
          'acuedd.other.menu.share'
      ),
    );
  }
}