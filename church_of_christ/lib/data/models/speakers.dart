
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Speaker{
  final String id;
  final String name;
  final String bio;
  final String company;
  final String twitter;
  final String fb;
  final String imagePath;

  Speaker({
    Key key,
    @required this.id,
    @required this.name,
    this.bio,
    this.company,
    this.twitter,
    this.fb,
    this.imagePath
  });

}

class AugmentedSpeaker {
  final String id;
  final String name;
  final String bio;
  final String company;
  final String twitter;
  final String github;
  final String linkedIn;
  final String imagePath;
  final String fb;

  AugmentedSpeaker({
    this.id,
    this.name,
    this.bio,
    this.imagePath,
    this.company,
    this.twitter,
    this.linkedIn,
    this.github,
    this.fb
  });

  factory AugmentedSpeaker.fromFireStore(DocumentSnapshot doc){
    Map data = doc.data;

    return AugmentedSpeaker(
      id: doc.documentID,
      name: data["name"] ?? "",
      bio: data["bio"] ?? "",
      company: data["company"] ?? "",
      twitter: data["twitter"] ?? "",
      fb: data["fb"] ?? "",
      imagePath: data["imagePath"] ?? "",
    );
  }

  factory AugmentedSpeaker.fromMap(Map data){
    return AugmentedSpeaker(
      id: data["docID"] ?? null,
      name: data["name"] ?? "",
      bio: data["bio"] ?? "",
      company: data["company"] ?? "",
      twitter: data["twitter"] ?? "",
      fb: data["fb"] ?? "",
      imagePath: data["imagePath"] ?? "",
    );
  }
}

class Track {
  final String id;
  final String name;
  final String color;

  Track(this.id, this.name, this.color);
}

class TalkType {
  final String id;
  final String name;
  final String materialIcon;

  final String description;

  TalkType(this.id, this.name, this.materialIcon, this.description);
}


class AugmentedTalk{
  final String title;
  final String description;
  final String speakerId;
  final Track track;
  final TalkType talkType;
  final String time;
  final int talkHash;

  AugmentedTalk(this.title, this.description, this.speakerId, this.track,
      this.talkType, this.time, this.talkHash);
}

class TalkBoss {
  final List<AugmentedTalk> talks;
  final AugmentedSpeaker speaker;
  int index = 0;


  TalkBoss(this.speaker,this.talks, [this.index]);

  AugmentedTalk get currentTalk{
    return talks[index];
  }

  factory TalkBoss.fromMap(Map data){
    return TalkBoss(
      AugmentedSpeaker.fromMap(data), null, null
    );
  }
}