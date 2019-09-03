

import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserInfo extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    final userPhoto = Container(
      width: 90.0,
      height: 90.0,
      margin: EdgeInsets.only(
        right: 20.0
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0,
          style: BorderStyle.solid
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(user.user.photoUrl)
        )
      ),
    );

    final userInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(
                bottom: 5.0
            ),
            child: Text(
                user.user.displayName,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                )
            )
        ),
        Text(
            user.user.email,
            style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Lato'
            )
        ),
      ],
    );

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 0.0,
      ),
      child: Row(
        children: <Widget>[
          userPhoto,
          userInfo,
        ],
      ),
    );
  }
}