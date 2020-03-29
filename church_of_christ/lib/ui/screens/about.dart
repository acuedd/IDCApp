import 'dart:io';

import 'package:church_of_christ/data/models/changelog.dart';
import 'package:church_of_christ/ui/screens/changelog.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/dialog_presentation.dart';
import 'package:church_of_christ/ui/widgets/dialog_round.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/list_cell.dart';
import 'package:church_of_christ/util/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

const List<Map<String, String>> _translators = [
  {'name': 'Edward Acu', 'language': 'English'},
  {'name': 'Edward Acu', 'language': 'Español'},
  {'name': 'Google translate', 'language': 'Portugues'},
];

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  initState() {
    super.initState();
    _initPackageInfo();
  }

  // Gets information about the app itself
  Future<Null> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return BlanckPage(
      title: "Información",
      body: ListView(children: <Widget>[
        HeaderText(text: "Sobre la app"),
        ListCell.icon(
          icon: Icons.info_outline,
          trailing: Icon(Icons.chevron_right),
          title: "Versión ${_packageInfo.version}",
          subtitle: "Eche un vistazo a los nuevos cambios",
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: ChangelogModel(),
                  child: ChangelogScreen(),
                ),
              ),
            ),
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.star_border,
          trailing: Icon(Icons.chevron_right),
          title: "¿Disfrutando de la app?",
          subtitle: "Deja tu experiencia en la Play Store",
          onTap: () async => {
            if(Platform.isAndroid){
              await FlutterWebBrowser.openWebPage(
                url: Url.playStore,
                androidToolbarColor: Theme.of(context).primaryColor,
              ),
            }
            else{
              await FlutterWebBrowser.openWebPage(
                url: Url.appStore,
                androidToolbarColor: Theme.of(context).primaryColor,
              ),
            }
          }
        ),

        HeaderText(text: "Autor"),
        ListCell.icon(
          icon: Icons.person_outline,
          trailing: Icon(Icons.chevron_right),
          title: "Aplicaciones libres",
          subtitle: "Bien diseñadas y hechas con amor",
          onTap: () async => {
            if(Platform.isAndroid){
              await FlutterWebBrowser.openWebPage(
                url: Url.authorStore,
                androidToolbarColor: Theme.of(context).primaryColor,
              ),
            }
            else{
              await FlutterWebBrowser.openWebPage(
                url: Url.authorAppStore,
                androidToolbarColor: Theme.of(context).primaryColor,
              ),
            }
          }
        ),
        ListCell.icon(
          icon: Icons.cake,
          trailing: Icon(Icons.chevron_right),
          title: "Conviértete en sponsor",
          subtitle: "Escríbeme en whatsapp",
          onTap: () => showDialog(
            context: context,
            builder: (context) => PresentationDialog.about(context, ()async{
              Navigator.pop(context, true);
              await FlutterWebBrowser.openWebPage(
                url: Url.apiContactMe,
                androidToolbarColor: Theme.of(context).primaryColor
              );
            },
            "Contáctame"
            ),
          ),
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.mail_outline,
          trailing: Icon(Icons.chevron_right),
          title: "Envíame un correo",
          subtitle: "Reporta fallos o solicita nuevas funciones",
          onTap: () async => await FlutterMailer.send(MailOptions(
            subject: Url.authorEmail['subject'],
            recipients: [Url.authorEmail['address']],
          )),
        ),
        HeaderText(text:"Créditos"),
        ListCell.icon(
          icon: Icons.translate,
          trailing: Icon(Icons.chevron_right),
          title: "Traducciones",
          subtitle: "¡Gracias a todos los contribuidores!",
          onTap: () => showDialog(
            context: context,
            builder: (context) => RoundDialog(
              title: "Traducciones",
              children: _translators
                  .map((translation) => ListCell(
                title: translation['name'],
                subtitle: translation['language'],
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 24,
                ),
              ))
                  .toList(),
            ),
          ),
        ),
        Separator.divider(indent: 72),
      ]),
    );
  }
}