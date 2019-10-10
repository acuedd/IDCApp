

import 'package:church_of_christ/data/models/user_repository.dart';
import 'package:church_of_christ/ui/screens/sign_in_screen.dart';
import 'package:church_of_christ/ui/widgets/dialog_round.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

/// List of past & current Patreon supporters.
/// Thanks to you all! :)
const List<String> _patreons = [
  'Edward Acu',
  'Nelson Matul',
];


class PresentationDialog extends StatelessWidget{

  final Widget body;
  final VoidCallback onPressed;
  final String textButton;
  const PresentationDialog({
    @required this.body,
    this.onPressed,
    this.textButton,
  });

  
  factory PresentationDialog.home(BuildContext context, VoidCallback onPressed, String textButton){
    return PresentationDialog(
      onPressed: onPressed,
      textButton: textButton,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.cake,
            size: 50,
            color: Theme.of(context).textTheme.caption.color,
          ),
          Icon(
            Icons.arrow_forward,
            size: 30,
            color: Theme.of(context).textTheme.caption.color,
          ),
          Icon(
            Icons.sentiment_satisfied,
            size: 50,
            color: Theme.of(context).textTheme.caption.color,
          ),
        ],
      ),
    );
  }

  factory PresentationDialog.about(BuildContext context, VoidCallback onPressed, String textButton) {
    return PresentationDialog(
      onPressed: onPressed,
      textButton: textButton,
      body: RowLayout(children: <Widget>[
        Text("Agradecemos a nuestros sponsors del app",
          style: Theme.of(context).textTheme.title.copyWith(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.caption.color,
          ),),
        for (String patreon in _patreons)
          Text(
            patreon,
            style: Theme.of(context).textTheme.title.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.caption.color,
            ),
          ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoundDialog(
      title: FlutterI18n.translate(context, 'about.presentation.title'),
      children: <Widget>[
        RowLayout(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: <Widget>[
            Text(
              FlutterI18n.translate(context, 'about.presentation.body'),
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.subhead.copyWith(
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
            body,
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      FlutterI18n.translate(context, 'about.presentation.dismiss'),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    onPressed: ()=> Navigator.pop(context,false),
                  ),
                  OutlineButton(
                    highlightedBorderColor: Theme.of(context).accentColor,
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.title.color,
                    ),
                    child: Text(textButton),
                    onPressed: onPressed,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}