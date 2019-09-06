

import 'package:church_of_christ/data/classes/abstract/query_model.dart';
import 'package:flutter/material.dart';

class EventModel extends QueryModel{

  @override
  Future loadData([BuildContext context]) {

  }
}

class myEvent{
  String id;
  String title;
  String description;
  String urlImage;
  int likes;
  bool liked;
  //User userOwner;
  String date;
  double price;
  String address;
  String urlFb;
  String urlTwitter;

  myEvent({
    this.id,
    this.title,
    this.description,
    this.urlImage,
    this.liked,
    this.likes,
    this.date,
    this.price,
    this.address,
    this.urlFb,
    this.urlTwitter,
  });
}