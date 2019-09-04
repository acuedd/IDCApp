
import 'package:church_of_christ/data/classes/abstract/query_model.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/util/url.dart';

/// Loads the app changelog, using the [Url.changelog] url.
class ChangelogModel extends QueryModel{

  @override
  Future loadData([BuildContext context]) async{
    if(await canLoadData()){
      items.add(await fetchData(Url.changelog));

      finishLoading();
    }
  }

  String get changeog => getItem(0) ?? "";
}