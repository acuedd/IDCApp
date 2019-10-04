

import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/widgets/circle_button.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserInfo extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    final userInfo = Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Card(
          elevation: 12.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(
              left: 46.0,
              bottom: 26.0
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 70.0, top: 10.0, right: 10.0, bottom: 20.0,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Hero(
                    tag: "name${user.user.displayName}",
                    child: Text(
                      "${user.user.displayName}",
                      style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold, fontFamily: 'Lato',),
                    ),
                  ),
                  Divider(height: 20.0,),
                  Text(
                      user.user.email,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Lato'
                      )
                  ),
                ]
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 26.0
          ),
          child: Hero(
            tag: "avatar${user.user.email}",
            child: CircleAvatar(
              backgroundImage: Utils.imageP(user.user.photoUrl),
              maxRadius: 46.0,
            ),
          ),
        )
      ],
    );

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 0.0,
      ),
      child: userInfo
    );
  }
}