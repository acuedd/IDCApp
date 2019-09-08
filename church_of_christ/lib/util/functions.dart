import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Functions{

  static String getImgResizeUrl(String url,height,width){
    return url; //'http://104.131.18.84/notice/tim.php?src=$url&h=$height&w=$width';
  }

}

class Utils {
  static Color convertIntColor(String color) {
    return Color(int.parse(color.replaceAll('#', ''), radix: 16))
        .withOpacity(1.0);
  }

  static Image image(String src, {height, width, fit}) {
    if (src.startsWith('http')) {
      return Image(image: CachedNetworkImageProvider(src),
          height: height,
          width: width,
          fit: fit);
    } else {
      return Image.asset(src, height: height, width: width, fit: fit);
    }
  }

  static imageP(String src) {
    if (src.startsWith('http')) {
      return CachedNetworkImageProvider(src);
    } else {
      return AssetImage(src);
    }
  }

  static getOrientationSideMargin(Orientation orientation) {
    return orientation == Orientation.portrait ? 26.0 : 96.0;
  }

  static getHeaderOrientationSideMargin(Orientation orientation) {
    return orientation == Orientation.portrait ? 20.0 : 90.0;
  }

  static getSpeakerOrientationTopMargin(Orientation orientation) {
    return orientation == Orientation.portrait ? 60.0 : 30.0;
  }

  static getTalkOrientationTopMargin(Orientation orientation) {
    return orientation == Orientation.portrait ? 106.0 : 40.0;
  }

}

class FadeRoute extends PageRoute {
  final Widget child;

  FadeRoute(this.child);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;


  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

}