
import 'dart:io';

import 'package:church_of_christ/data/models/speakers.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/pages/my_events.dart';
import 'package:church_of_christ/ui/widgets/speaker_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'event.dart';

class DbChurch with ChangeNotifier {
  final String USERS = "users";
  final String EVENTSCHURCH = "events";
  final String SPEAKERS = "speakers";
  final String SCHEDULE = "schedule";
  final String ADMISSIONS = "admissions";

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageReference _storageReference = FirebaseStorage.instance.ref();
  Geoflutterfire geo = Geoflutterfire();

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
      'baptismDate': user.baptismDate,
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

  Future<void> addEvent(EventModel myEvent) async{
    CollectionReference refEvents = _db.collection(EVENTSCHURCH);
    //GeoFirePoint point = geo.point(latitude: myEvent.location.latitude, longitude: myEvent.location.longitude);

    await _auth.currentUser().then((FirebaseUser user){
      refEvents.add({
        'urlImage': myEvent.urlImage,
        'title': myEvent.title,
        'description': myEvent.description,
        'address': myEvent.address,
        'currency': myEvent.currency,
        'price': myEvent.price,
        'urlVideo': myEvent.urlVideo,
        'urlTwitter': myEvent.urlTwitter,
        'urlFb': myEvent.urlFb,
        'dateTime': myEvent.dateTime,
        'userOwner': _db.document("${USERS}/${user.uid}"), //reference
        'released': false,
        'speakers': myEvent.spearkers,
        //'position': (point!= null)?point.data:null,
        'latitude': myEvent.latitude,
        'longitude': myEvent.longitude,
      });
    });
  }

  void updateEvent(EventModel myEvent) async{
    DocumentReference refEvents = _db.collection(EVENTSCHURCH).document(myEvent.id);
    //GeoFirePoint point = geo.point(latitude: myEvent.location.latitude, longitude: myEvent.location.longitude);

    return await refEvents.setData({
      'id': refEvents.documentID,
      //'urlImage': myEvent.urlImage,
      'title': myEvent.title,
      'description': myEvent.description,
      'address': myEvent.address,
      'currency': myEvent.currency,
      'price': myEvent.price,
      'urlVideo': myEvent.urlVideo,
      'urlTwitter': myEvent.urlTwitter,
      'urlFb': myEvent.urlFb,
      'dateTime': myEvent.dateTime,
      //'position': (point!= null)?point.data:null,
      'latitude': myEvent.latitude,
      'longitude': myEvent.longitude,
    }, merge: true);
  }

  void deleteEvent(EventModel myEvent) async{
    DocumentReference refEvents = _db.collection(EVENTSCHURCH).document(myEvent.id);
    refEvents.delete();
  }

  Future<StorageUploadTask> uploadFile(String path, File image) async{
    return _storageReference.child(path).putFile(image);
  }

  Stream<QuerySnapshot> streamEventsPerUser(String uid){
    return _db.collection(EVENTSCHURCH).where("userOwner",isEqualTo: _db.document("${USERS}/${uid}"))
              .snapshots();
  }

  Stream<QuerySnapshot> streamEvents(){
    return _db.collection(EVENTSCHURCH).snapshots();
  }
  
  Stream<QuerySnapshot> streamEventsCommingSoon(){
    return _db.collection(EVENTSCHURCH).orderBy("dateTime").snapshots();
  }

  List<ItemEventsSearch> buildEvents(List<DocumentSnapshot> eventsListSnapshot, User user){
    List<ItemEventsSearch> myEvents = List<ItemEventsSearch>();

    eventsListSnapshot.forEach((p){
      EventModel event = EventModel.fromFirestore(p);
      myEvents.add(ItemEventsSearch(myEvent: event, myUser: user,));
    });

    return myEvents;
  }

  List<ItemEventsSearch> buildEventsFromMap(List results, User user){
    List<ItemEventsSearch> myEvents = List<ItemEventsSearch>();

    results.forEach((q){
      myEvents.add(ItemEventsSearch(myEvent: q, myUser: user,));
    });
    return myEvents;
  }

  getEventsByUser(String uid){
    return _db.collection(EVENTSCHURCH).where("userOwner", isEqualTo: _db.document("${USERS}/${uid}")).getDocuments();
  }

  getSearchEvent(String searchField){
    return _db.collection(EVENTSCHURCH).where("title", isEqualTo: searchField).getDocuments();
  }

  Future<void> addAdmission( RegisterEvent registerEvent) async{
    CollectionReference reference = _db.collection(ADMISSIONS);
    await _auth.currentUser().then((FirebaseUser user){
      reference.add({
        "name":registerEvent.name,
        "church": registerEvent.church,
        "currency": registerEvent.currency,
        "price": registerEvent.price,
        "eventid": registerEvent.eventid,
        "userid": registerEvent.userid,
        "nameUserReg": registerEvent.nameUserReg,
      });
    });
  }

  Future<void> addSpeaker(Speaker speaker, User userLoad) async{
    CollectionReference reference = _db.collection(SPEAKERS);
    await _auth.currentUser().then((FirebaseUser user){
      reference.add({
        "imagePath": speaker.imagePath,
        "name": speaker.name,
        "bio": speaker.bio,
        "company": speaker.company,
         "twitter": speaker.twitter,
        "fb": speaker.fb,
        "userReference": _db.document("${USERS}/${userLoad.uid}"),
        'regBy': _db.document("${USERS}/${user.uid}"),
      });
    });
  }

  void updateSpeaker(Speaker speaker) async{
    DocumentReference reference = _db.collection(SPEAKERS).document(speaker.id);
    return await reference.setData({
      "id": reference.documentID,
      "imagePath": speaker.imagePath,
      "name": speaker.name,
      "bio": speaker.bio,
      "company": speaker.company,
      "twitter": speaker.twitter,
      "fb": speaker.fb,
    }, merge: true);
  }

  void deleteSpeaker(Speaker speaker) async{
    DocumentReference reference = _db.collection(SPEAKERS).document(speaker.id);
    reference.delete();
  }

  Stream<QuerySnapshot> streamSpeakers(){
    return _db.collection(SPEAKERS).snapshots();
  }

  Stream<QuerySnapshot> streamUsers(){
    return _db.collection(USERS).snapshots();
  }

  List<SpeakerItem> buildSpeakers(List<DocumentSnapshot> speakerListSnapshot){
    List<SpeakerItem> speakerList = List<SpeakerItem>();

    speakerListSnapshot.forEach((p){
      var mydata = p.data;
      mydata["docID"] = p.documentID;
      var myTalkboss = TalkBoss.fromMap(mydata);
      speakerList.add(SpeakerItem(myTalkboss));
    });
    return speakerList;
  }

  Future<void> addSpeakerToEvent(AugmentedSpeaker speaker, EventModel eventModel) async{
    DocumentReference reference = _db.collection(EVENTSCHURCH).document(eventModel.id);
    reference.updateData({
      'speakers': FieldValue.arrayUnion([_db.document("${SPEAKERS}/${speaker.id}")])
    });
  }

  Future<void> addUserToEvent(AugmentedSpeaker speaker, EventModel eventModel) async{
    DocumentReference reference = _db.collection(EVENTSCHURCH).document(eventModel.id);
    reference.updateData({
      'admissions': FieldValue.arrayUnion([_db.document("${USERS}/${speaker.id}")])
    });

  }

  Future<void> removeSpeakerToEvent(AugmentedSpeaker speaker, EventModel eventModel) async{
    DocumentReference reference = _db.collection(EVENTSCHURCH).document(eventModel.id);
    reference.updateData({
      'speakers': FieldValue.arrayRemove([_db.document("${SPEAKERS}/${speaker.id}")])
    });
  }

  Future<void> removeAdmissionToEvent(AugmentedSpeaker speaker, EventModel eventModel) async{
    //Aca uso el AugmentedSpeaker xq cuando obtengo datos casteo un User a un AugmentedSpeaker
    DocumentReference reference = _db.collection(EVENTSCHURCH).document(eventModel.id);
    reference.updateData({
      "admissions": FieldValue.arrayRemove([_db.document("${USERS}/${speaker.id}")])
    });
  }

  Stream streamEventbyId(EventModel eventModel){
    return _db.collection(EVENTSCHURCH).document(eventModel.id).snapshots();
  }

  Future<AugmentedSpeaker> getSpeaker(String id) async{
    var snap = await _db.collection(SPEAKERS).document(id).get();
    return AugmentedSpeaker.fromFireStore(snap);
  }

  Future<EventModel> getEventData(String id) async{
    var snap = await _db.collection(EVENTSCHURCH).document(id).get();
    return EventModel.fromFirestore(snap);
  }

  Stream getSpeakerList(EventModel eventModel){
    return _db.collection(EVENTSCHURCH).document(eventModel.id).collection("speakers").snapshots();

  }
  
  Stream streamSchedule(EventModel eventModel){
    return _db.collection(SCHEDULE).orderBy("dateTime").where("eventId",isEqualTo: eventModel.id).snapshots();
  }
  
  Stream streamAdmisionByUser(EventModel eventModel, User user){
    return _db.collection(ADMISSIONS).where("eventid", isEqualTo: eventModel.id)
        .where("userid", isEqualTo: user.uid).snapshots();
  }

  Stream streamAdmission(EventModel eventModel){
    return _db.collection(ADMISSIONS).where("eventid", isEqualTo: eventModel.id).snapshots();
  }
}






























