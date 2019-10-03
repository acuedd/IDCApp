
import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/user.dart';
import 'package:church_of_christ/ui/pages/detail_page.dart';
import 'package:church_of_christ/ui/pages/my_events.dart';
import 'package:church_of_christ/ui/widgets/fade_in_route.dart';
import 'package:church_of_christ/ui/widgets/page_transformer.dart';
import 'package:flutter/material.dart';

class IntroNewsItem extends StatelessWidget {
  IntroNewsItem({
    @required this.item,
    @required this.pageVisibility,
    this.category,
    this.myUser,
    this.scaffoldContext,
  });

  final String category;
  final EventModel item;
  final PageVisibility pageVisibility;
  final User myUser;
  final BuildContext scaffoldContext;

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return new Opacity(
      opacity: pageVisibility.visibleFraction,
      child: new Transform(
        alignment: FractionalOffset.topLeft,
        transform: new Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final categoryText = _applyTextEffects(
      translationFactor: 300.0,
      child: new Text(
        (category != null)? category: "",
        style: textTheme.caption.copyWith(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.center,
      ),
    );

    final titleText = _applyTextEffects(
      translationFactor: 200.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: new Text(
          item.title,
          style: textTheme.title
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return new Positioned(
      bottom: 56.0,
      left: 32.0,
      right: 32.0,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          categoryText,
          titleText,
        ],
      ),
    );
  }

  Widget _getImageNetwork(url){

    try{
      if(url != '') {

        return ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: new FadeInImage.assetNetwork(
            placeholder: 'assets/images/place_holder.jpg',
            image: url,
            fit: BoxFit.cover,
            alignment: new FractionalOffset(
              0.5 + (pageVisibility.pagePosition / 3),
              0.5,
            ),
          ),
        );
      }else{
        return new Image.asset('assets/images/place_holder_2.jpg');
      }

    }catch(e){
      return new Image.asset('assets/images/place_holder_2.jpg');
    }

  }

  String _getImageUrl(url,height,width){
    return url;//'http://104.131.18.84/notice/tim.php?src=$url&h=$height&w=$width';=
  }

  @override
  Widget build(BuildContext context) {

    final imageOverlayGradient = new DecoratedBox(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0x00000000),
          ],
        ),
      ),
    );

    return new Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: new Material(
        elevation: 4.0,
        borderRadius: new BorderRadius.circular(8.0),
        child: InkWell(
          onTap: (){
            openDetail(context);
          },
          child: new Stack(
            fit: StackFit.expand,
            children: [
              new Hero(tag: item.title,child: _getImageNetwork(_getImageUrl(item.urlImage, 400, ''))),
              _getOverlayGradient(),
              _buildTextContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  _getOverlayGradient() {

    return ClipRRect(
      borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(8.0)),
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: FractionalOffset.bottomCenter,
            end: FractionalOffset.topCenter,
            colors: [
              const Color(0xFF000000),
              const Color(0x00000000),
            ],
          ),
        ),
      ),
    );
  }


  void openDetail(BuildContext context) {
    Navigator.of(context).push(FadeInRoute(
        widget:Container(
          child: DetailPage(myEvent: item, myUserLogged: myUser)
        )
    ));
  }
}
