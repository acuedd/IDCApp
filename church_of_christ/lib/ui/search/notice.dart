

import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/ui/pages/detail_page.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notice extends StatelessWidget{
  final EventModel eventModel;

  AnimationController animationController;
  Notice(this.eventModel);


  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return new GestureDetector(
      onTap: _handleTapUp,
      child: new Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
        child: new Material(
          borderRadius: new BorderRadius.circular(6.0),
          elevation: 2.0,
          child: _getListTile(),
        ),
      ),
    );
  }

  Widget _getListTile(){
    return new Container(
      height: 95.0,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Hero(
            tag: eventModel.id, child: _getImgWidget(Functions.getImgResizeUrl(eventModel.urlImage, 200, 200)),
          ),
          _getColumnText(eventModel.title, eventModel.dateTime, eventModel.description),
        ],
      ),
    );
  }

  _handleTapUp(){
    Navigator.of(_context).push(
        new MaterialPageRoute(builder: (BuildContext context) {
          return new DetailPage(myEvent: eventModel,);
        })
    );
  }

  Widget _getColumnText(title, date, description ){
    return new Expanded(
      child: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getTitleWidget(title),
            _getDateWidget(date),
            _getDescriptionWidget(description),
          ],
        ),
      ),
    );
  }

  _getImgWidget(String url){
    return new Container(
      width: 95.0,
      height: 95.0,
      child: new ClipRRect(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(6.0),
          bottomLeft: const Radius.circular(6.0),
        ),
        child: _getImageNetwork(url),
      ),
    );
  }

  Widget _getImageNetwork(String url){

    try{
      if(url.isNotEmpty) {

        return new FadeInImage.assetNetwork(
          placeholder: 'assets/images/place_holder.jpg',
          image: url,
          fit: BoxFit.cover,);

      }else{
        return new Image.asset('assets/images/place_holder.jpg');
      }

    }catch(e){
      return new Image.asset('assets/images/place_holder.jpg');
    }

  }

  Text _getTitleWidget(String currencyName){
    return new Text(
      currencyName,
      maxLines: 1,
      style: new TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato'),
    );
  }

  Widget _getDescriptionWidget(String description){
    return new Container(
      margin: new EdgeInsets.only(top: 3.0),
      child: new Text(description, maxLines: 2,),
    );
  }

  Widget _getDateWidget(DateTime date){
    return new Text(
      DateFormat.yMMMd().add_jm().format(date),
      style: new TextStyle(color: Colors.grey, fontSize: 10.0, fontFamily: 'Lato'),
    );
  }
}