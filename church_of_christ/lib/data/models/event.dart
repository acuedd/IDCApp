

import 'package:church_of_christ/data/classes/abstract/query_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventModelProvider extends QueryModel{

  @override
  Future loadData([BuildContext context]) {

  }
}

class EventModel{
  final String id;
  final String title;
  final String urlImage;
  final String description;
  final DateTime dateTime;

  final int likes;
  final bool liked;
  //User userOwner;
  String date;
  final String currency;
  final double price;
  final String address;
  final String urlFb;
  final String urlTwitter;
  String urlVideo;
  final String location;
  List<String> listImages;

  EventModel({
    @required this.id,
    @required this.title,
    @required this.urlImage,
    @required this.dateTime,
    @required this.description,
    @required this.price,
    @required this.address,
    @required this.currency,
    this.urlVideo,
    this.listImages,
    this.likes,
    this.liked,
    this.location,
    this.urlFb,
    this.urlTwitter,
  }){
    this.date = this.dateTime.toString();
    if(this.urlVideo == null)
      this.urlVideo = "";
    if(this.listImages == null)
      this.listImages = [this.urlImage];
  }

  factory EventModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data;
    String date = data["dateTime"].toDate().toString();
    DateTime secondDate = DateTime.parse(date);

    return EventModel(
      id: doc.documentID,
      title: data["title"] ?? "",
      urlImage: data["urlImage"] ?? "",
      description: data["description"] ?? "",
      dateTime: secondDate,
      currency: data["currency"] ?? "",
      price: data["price"] ?? 0.0,
      address: data["address"] ?? "",
      urlVideo: data["urlVideo"] ?? "",
      urlTwitter: data["urlTwitter"] ?? "",
      urlFb: data["urlFb"] ?? ""
    );
  }

}