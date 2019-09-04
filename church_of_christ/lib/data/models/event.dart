

import 'package:church_of_christ/data/classes/abstract/query_model.dart';
import 'package:flutter/material.dart';

class EventModel extends QueryModel{

  @override
  Future loadData([BuildContext context]) {

  }
}

class Event{
  String id;
  String name;
  String description;
  String urlImage;
  int likes;
  bool liked;
  //User userOwner;
  DateTime date;
  double price;
  String address;
  String urlFb;
  String urlTwitter;

  Event({
    this.id,
    this.name,
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