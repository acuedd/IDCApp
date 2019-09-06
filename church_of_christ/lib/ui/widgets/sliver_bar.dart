import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverBar extends StatelessWidget{
  static const double heightRatio = 0.3;

  final String title;
  final Widget header;
  final num height;
  final List<Widget> actions;

  const SliverBar({
    this.title,
    this.header,
    this.height = heightRatio,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return _getSliverBar(context);
  }

  Widget _getSliverBar(BuildContext context){
    return SliverAppBar(
      expandedHeight:  MediaQuery.of(context).size.height * height,
      actions: actions,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: ConstrainedBox(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              fontFamily: "Lato",
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0,0),
                  blurRadius: 4,
                  color: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.55,
          ),
        ),
        background: header,
      ),
    );
  }
}