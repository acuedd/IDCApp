import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User{
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final bool isAdmin;
  //final List<Churchs> myPlaces;
  //final List<Churchs> myFavoritePlaces;
  //final List<Events> myEvents;

  User({
    Key key,
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.photoURL,
    this.isAdmin,
    //this.myPlaces,
    //this.myFavoritePlaces
  });
}

class UserDB {
  final String USERS = "users";

  final Firestore _db = Firestore.instance;

  Future<void> updateUserData(User user) async{
    DocumentReference ref = _db.collection(USERS).document(user.uid);
    return await ref.setData({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoURL': user.photoURL,
      //'myPlaces': user.myPlaces,
      //'myFavoritePlaces': user.myFavoritePlaces,
      'isAdmin': user.isAdmin,
      'lastSignIn': DateTime.now()
    }, merge: true);
  }
}