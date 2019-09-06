

import 'package:add_2_calendar/add_2_calendar.dart' as prefix0;
import 'package:church_of_christ/data/models/event.dart';

class IntroNews {
  IntroNews(this.title,
      this.category,
      this.imageUrl,
      this.description,
      this.date,
      this.link,
      this.origin);

  final String title;
  final String category;
  final String imageUrl;
  final String date;
  final String description;
  final String link;
  final String origin;

  IntroNews.fromNotice(myEvent notice) :
        title = notice.title,
        category = "proximamente",
        imageUrl = notice.urlImage,
        description = notice.description,
        date = notice.date,
        link = notice.urlFb,
        origin = notice.address;
}