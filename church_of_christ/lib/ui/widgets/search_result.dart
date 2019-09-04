

import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {

  final String query;

  SearchView(this.query);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(query),
    );
  }
}