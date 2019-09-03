
import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/pages/user_info.dart';
import 'package:church_of_christ/ui/widgets/circle_button.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/gradient_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';


class ProfileHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    final ButtonsBar = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 10.0
      ),
      child: Row(
        children: <Widget>[
          //Cerrar Sesión
          CircleButton(
              false,
              Icons.exit_to_app, 40.0,
              Color.fromRGBO(255, 255, 255, 0.6),
              () => {
                Provider.of<UserRepository>(context).signOut()
              }
          ),
        ],
      ),
    );

    final String data = user.user.email;

    final codeQR = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 16,),
          QrImage(
            data: data,
            gapless: true,
            size: 250,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
          )
        ],
      ),
    );

    final Cont = Container(
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 0.0
      ),
      child: Column(
        children: <Widget>[
          UserInfo(),
          Stack(
            children: <Widget>[
              GradientBack(height: 275,colors: [
                Color(0xFFf0ffff),
                Color(0xFFe7ffba),
              ],),
              codeQR
            ],
          )

        ],
      ),
    );

    return BlanckPage(
      title: FlutterI18n.translate(context, 'Profile'),
      actions: <Widget>[
        PopupSettins(context)
      ],
      body: ListView(children: <Widget>[
          Cont
        ]
      ),
    );
  }

  Widget PopupSettins(BuildContext myContext){
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "closeSession",
          child: Text('Cerrar sesión'),
        )
      ],
      onSelected: (text){
        print(text);
        if(text == "closeSession"){
          Provider.of<UserRepository>(myContext).signOut();
        }
      },
    );
  }

}