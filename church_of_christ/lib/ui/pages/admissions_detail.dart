
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:row_collection/row_collection.dart';

class AdmissionsDetail extends StatefulWidget{

  final EventModel myEvent;
  final User myUserLogged;
  final List<RegisterEvent> listAdmissions;
  AdmissionsDetail({
    Key key,
    this.myEvent,
    this.myUserLogged,
    this.listAdmissions,
  });

  @override
  State createState() {
    return _AdmissionsDetail();
  }
}

class _AdmissionsDetail extends State<AdmissionsDetail>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'acuedd.events.list' )),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              HeaderText(text:FlutterI18n.translate(
                context,
                'acuedd.events.registerAdmission',
              )),
              Expanded(
                child: ListAdmission( widget.listAdmissions, widget.myUserLogged),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListAdmission extends StatelessWidget {
  final List<RegisterEvent> listAdmissions;
  final User userlogged;
  ListAdmission(this.listAdmissions, this.userlogged);

  Widget _buildProductItem(BuildContext context, int index) {

    MoneyFormatterOutput fo = FlutterMoneyFormatter(
        amount: listAdmissions[index].price,
        settings: MoneyFormatterSettings(
          symbol: listAdmissions[index].currency,
          thousandSeparator: ',',
          decimalSeparator: '.',
        )
    ).output;

    return Card(
      child: RowLayout(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0, bottom: 25.0),
        children: <Widget>[
          RowText(
            "${FlutterI18n.translate(context, 'acuedd.events.name')}:",
            listAdmissions[index].name,
          ),
          RowText(
            "${FlutterI18n.translate(context, 'acuedd.events.church')}:",
            listAdmissions[index].church,
          ),
          RowText(
            "${FlutterI18n.translate(context, 'acuedd.events.contribution')}:",
            fo.symbolOnLeft,
          ),
          if(userlogged == null)
            RowText(
                "${FlutterI18n.translate(context, 'app.regby')}:",
                "${listAdmissions[index].nameUserReg}"
            )
          //Text(, style: TextStyle(color: Colors.deepPurple))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildProductItem,
      itemCount: listAdmissions.length,
    );
  }
}