import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';


class User{
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  bool isAdmin;
  DateTime birthday;
  bool baptized;
  DateTime baptismDate;
  //final List<Churchs> myPlaces;
  //final List<Churchs> myFavoritePlaces;
  //final List<Events> myEvents;

  User({
    Key key,
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.photoURL,
    @required this.birthday,
    @required this.baptized,
    @required this.baptismDate,
    @required this.isAdmin,
    //this.myPlaces,
    //this.myFavoritePlaces
  });

  factory User.fromMap(Map data) {
    String date = data["birthday"].toDate().toString();
    DateTime second = DateTime.parse(date);
    String bpDateStr = data["baptismDate"].toDate().toString();
    DateTime bpDate = DateTime.parse(bpDateStr);
    return User(
      uid: data['uid'] ?? "",
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      photoURL: data["photoURL"] ?? "",
      isAdmin: data["isAdmin"] ?? "",
      birthday: second,
      baptized: data["baptized"] ?? "",
      baptismDate: bpDate,
    );
  }

}
