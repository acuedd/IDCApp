
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String id;
  final String eventId;
  final String title;
  final String overView;
  final String tile;
  final DateTime dateTime;
  final String speakerTalk;
  final String avatarSpeaker;
  final String nameSpeaker;
  final String tag;
  final String colorTag;


  ScheduleModel({
    this.id,
    this.eventId,
    this.title,
    this.overView,
    this.tile,
    this.dateTime,
    this.speakerTalk,
    this.avatarSpeaker,
    this.nameSpeaker,
    this.tag,
    this.colorTag,

  });

  factory ScheduleModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data;
    String date = data["dateTime"].toDate().toString();
    DateTime secondDate = DateTime.parse(date);

    return ScheduleModel(
      id: doc.documentID,
      eventId: data["eventId"] ?? "",
      title: data["title"] ?? "",
      overView: data["overView"] ?? "",
      tile: data["tile"] ?? "",
      dateTime: secondDate,
      speakerTalk: data["speakerTalk"] ?? "",
      avatarSpeaker: data["avatarSpeaker"] ?? "",
      nameSpeaker: data["nameSpeaker"] ?? "",
      tag: data["tag"] ?? "",
      colorTag: data["colorTag"] ?? "",
    );
  }

}