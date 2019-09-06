
import 'package:church_of_christ/data/models/app_model.dart';
import 'package:church_of_christ/ui/widgets/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

class CardPage extends StatelessWidget{

  final Widget body;

  const CardPage(this.body);

  factory CardPage.header({
    Widget leading,
    Widget subtitle,
    @required String title,
    @required String details,
  }){
    return CardPage(
      RowLayout(children: <Widget>[
        Row(children: <Widget>[
          if(leading != null) leading,
          Separator.spacer(space: 12),
          Expanded(
            child: RowLayout(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 6,
              children: <Widget>[
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(subtitle != null) subtitle,
              ],
            ),
          ),
        ]),
        Separator.divider(),
        TextExpand(details),
      ],)
    );
  }

  factory CardPage.body({
    String title,
    @required Widget body,
  }){
    return CardPage(
      RowLayout(
        children: <Widget>[
          if(title != null)
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Lato",
                fontWeight: FontWeight.bold,
              ),
            ),
          body
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Provider.of<AppModel>(context).theme == Themes.black
              ? Theme.of(context).dividerColor
              : Colors.transparent,
        )
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}