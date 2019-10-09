

import 'package:church_of_christ/data/classes/abstract/query_model.dart';
import 'package:church_of_christ/data/models/speakers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class EventModelProvider extends QueryModel{

  @override
  Future loadData([BuildContext context]) {

  }
}

class EventModel{
  final String id;
  final String title;
  final String urlImage;
  final String filename;
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
  final LatLng location;
  final double latitude;
  final double longitude;
  List<String> listImages;
  List<String> spearkers;
  List<String> admissions;

  EventModel({
    @required this.id,
    @required this.title,
    @required this.filename,
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
    this.latitude,
    this.longitude,
    this.urlFb,
    this.urlTwitter,
    this.spearkers,
    this.admissions
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
    List<String> speakers = [];
    List<String> users = [];

    if(data["speakers"] != null){
      var speakerList = data["speakers"];

      for(var item in speakerList){
        speakers.add(item.documentID);
      }

      /*for(var item in speakerList){
        var test = item.get();
        AugmentedSpeaker tempo;
        test.then((snap){
          tempo = AugmentedSpeaker.fromFireStore(snap);
          //print(speakers);
        });
        //speakers.add(tempo);
      }*/
    }
    if(data["admissions"] != null){
      var userList = data["admissions"];
      for(var item in userList){
        users.add(item.documentID);
      }
    }

    //print(speakers.length);
    return EventModel(
      id: doc.documentID,
      title: data["title"] ?? "",
      urlImage: data["urlImage"] ?? "",
      filename: data["filename"] ?? "",
      description: data["description"] ?? "",
      dateTime: secondDate,
      currency: data["currency"] ?? "",
      price: data["price"] ?? 0.0,
      address: data["address"] ?? "",
      urlVideo: data["urlVideo"] ?? "",
      urlTwitter: data["urlTwitter"] ?? "",
      urlFb: data["urlFb"] ?? "",
      spearkers: speakers ?? [],
      latitude: data["latitude"] ?? 0,
      longitude: data["longitude"] ?? 0,
      admissions: users ?? []
    );
  }
}

class RegisterEvent{
  final String name;
  final String church;
  final int age;
  final String civilStatus;
  final String gender;
  final String currency;
  final double price;
  final String eventid;
  final String userid;
  final String nameUserReg;


  RegisterEvent({
    this.name,
    this.church,
    this.age,
    this.civilStatus,
    this.gender,
    this.currency,
    this.price,
    this.eventid,
    this.userid,
    this.nameUserReg,
  });

  factory RegisterEvent.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data;
    return RegisterEvent(
      name: data["name"] ?? "",
      church: data["church"] ?? "",
      age: data["age"] ?? 0,
      civilStatus: data["civilStatus"] ?? "",
      gender: data["gender"] ?? "",
      currency: data["currency"] ?? "",
      price: data["price"] ?? "",
      eventid: data["eventid"] ?? "",
      userid: data["userid"] ?? "",
      nameUserReg: data["nameUserReg"] ?? ""
    );
  }
}