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

  void convertDateFromString(String strDate){
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
    print(formatDate(todayDate, [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));
  }
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
      'lastSignIn': DateTime.now(),
      'birthday': user.birthday,
      'baptized': user.baptized,
      'baptismDate': user.baptismDate
    }, merge: true);
  }

  Future<void> updateBirthday(User user) async{
    DocumentReference refUser = _db.collection(USERS).document(user.uid);
    refUser.updateData({
      "birthday": user.birthday
    });
  }

  Future<void> updateBaptized(User user) async{
    DocumentReference refUser = _db.collection(USERS).document(user.uid);
    refUser.updateData({
      "baptized": user.baptized
    });
  }

  Future<void> updateBaptismDate(User user) async{
    DocumentReference refUser = _db.collection(USERS).document(user.uid);
    refUser.updateData({
      "baptismDate": user.baptismDate
    });
  }

  Future<User> getUser(String id) async {
    var snap = await _db.collection(USERS).document(id).get();

    return User.fromMap(snap.data);
  }

  Stream<User> streamUser(String id) {
    return _db.collection(USERS)
          .document(id)
          .snapshots()
          .map((snap) => User.fromMap(snap.data));
  }
}
