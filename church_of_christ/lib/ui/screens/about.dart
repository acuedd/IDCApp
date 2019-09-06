import 'package:church_of_christ/data/models/changelog.dart';
import 'package:church_of_christ/ui/screens/changelog.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/dialog_round.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/list_cell.dart';
import 'package:church_of_christ/util/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
      title: FlutterI18n.translate(context, 'app.menu.about'),
      body: ListView(children: <Widget>[
        HeaderText(text: FlutterI18n.translate(
            context,
            'about.headers.about'
        )),
        ListCell.icon(
          icon: Icons.info_outline,
          trailing: Icon(Icons.chevron_right),
          title: FlutterI18n.translate(
            context,
            'about.version.title',
            {'version': _packageInfo.version},
          ),
          subtitle: FlutterI18n.translate(
            context,
            'about.version.body'
          ),
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
          title: FlutterI18n.translate(
              context,
              'about.review.title',
          ),
          subtitle: FlutterI18n.translate(
              context,
              'about.review.body',
          ),
          onTap: () async => await FlutterWebBrowser.openWebPage(
            url: Url.appStore,
            androidToolbarColor: Theme.of(context).primaryColor,
          ),
        ),

        HeaderText(text: FlutterI18n.translate(
          context,
          'about.headers.author',
        )),
        ListCell.icon(
          icon: Icons.person_outline,
          trailing: Icon(Icons.chevron_right),
          title: FlutterI18n.translate(
            context,
            'about.author.title',
          ),
          subtitle: FlutterI18n.translate(
            context,
            'about.author.body',
          ),
          onTap: () async => await FlutterWebBrowser.openWebPage(
            url: Url.authorStore,
            androidToolbarColor: Theme.of(context).primaryColor,
          ),
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.mail_outline,
          trailing: Icon(Icons.chevron_right),
          title: FlutterI18n.translate(
            context,
            'about.email.title',
          ),
          subtitle: FlutterI18n.translate(
            context,
            'about.email.body',
          ),
          onTap: () async => await FlutterMailer.send(MailOptions(
            subject: Url.authorEmail['subject'],
            recipients: [Url.authorEmail['address']],
          )),
        ),
        HeaderText(text:FlutterI18n.translate(
          context,
          'about.headers.credits',
        )),
        ListCell.icon(
          icon: Icons.translate,
          trailing: Icon(Icons.chevron_right),
          title: FlutterI18n.translate(
            context,
            'about.translations.title',
          ),
          subtitle: FlutterI18n.translate(
            context,
            'about.translations.body',
          ),
          onTap: () => showDialog(
            context: context,
            builder: (context) => RoundDialog(
              title: FlutterI18n.translate(
                context,
                'about.translations.title',
              ),
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