
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

  AugmentedSpeaker({
    this.id,
    this.name,
    this.bio,
    this.imagePath,
    this.company,
    this.twitter,
    this.linkedIn,
    this.github
  });
}


class TalkBoss {
  final AugmentedSpeaker speaker;
  int index = 0;


  TalkBoss(this.speaker);
}