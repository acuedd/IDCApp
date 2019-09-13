

import 'package:church_of_christ/ui/widgets/floating_action_button_green.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';

class CardImageWithFabIcon  extends StatelessWidget{

  final double height;
  final double width;
  double left;
  var imageFile;
  final VoidCallback onPressedFabIcon;
  final IconData iconData;
  bool internet = true;

  CardImageWithFabIcon({
    Key key,
    @required this.imageFile,
    @required this.width,
    @required this.height,
    @required this.onPressedFabIcon,
    @required this.iconData,
    this.internet,
    this.left
  });

  @override
  Widget build(BuildContext context) {
    print(imageFile);
    final card = Container(
      height: height, 
      width: width,
      margin: EdgeInsets.only(left: left),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: internet? Utils.imageP(imageFile) :new FileImage(imageFile)
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black38,
            blurRadius: 15.0,
            offset: Offset(0.0,7.0)
          )
        ]
      ),

    );
    
    return Stack(
      alignment: Alignment(0.9,1.1),
      children: <Widget>[
        card,
        FloatingActionButtonGreen(iconData: iconData, onPressed: onPressedFabIcon,)
      ],
    );

  }
}