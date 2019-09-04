
import 'package:church_of_christ/util/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class PopupSettins extends StatelessWidget{
  final Map<String, String> popupMenu = Menu.home;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => popupMenu.keys
          .map((string) => PopupMenuItem(
        value: string,
        child:
        Text(FlutterI18n.translate(context, string)),
      ))
          .toList(),
      onSelected: (text) =>
          Navigator.pushNamed(context, popupMenu[text]),
    );
  }
}