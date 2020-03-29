import 'package:church_of_christ/data/models/app_model.dart';
import 'package:church_of_christ/ui/tabs/churchs.dart';
import 'package:church_of_christ/ui/widgets/search.dart';
import 'package:church_of_christ/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class musicCollection extends StatefulWidget{

  musicCollection({
    Key key
  });

  @override
  State createState() {
    return _musicCollection();
  }
}

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);
var mm = '🎵';
var flume = 'https://i.scdn.co/image/8d84f7b313ca9bafcefcf37d4e59a8265c7d3fff';
var martinGarrix =
    'https://c1.staticflickr.com/2/1841/44200429922_d0cbbf22ba_b.jpg';
var rosieLowe =
    'https://i.scdn.co/image/db8382f6c33134111a26d4bf5a482a1caa5f151c';

class _musicCollection extends State<musicCollection>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: blueColor,
      body:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SearchWidget(
                textHint: 'Search Music...',
              ),
              SizedBox(height: 32.0,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text('Colecciones',
                    style: GetTextStyle.getHeadingMusic(context),
                  ),
                ),
              SizedBox(height: 16.0,),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      itemCollection(imagePath: 'assets/images/orange.jpg', title: 'En momentos así'),
                      itemCollection(imagePath: 'assets/images/orange.jpg', title: 'A tu prescencia'),
                      itemCollection(imagePath: 'assets/images/orange.jpg', title: 'Coro campesina'),
                      itemCollection(imagePath: 'assets/images/orange.jpg', title: 'Pinares del Norte'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text('Recomendados',
                  style: GetTextStyle.getHeadingMusic(context),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          SizedBox(height: 16.0,),
                          SongItem('Efecto Dominó', 'Edy Tercero', martinGarrix),
                          SongItem('Never Be Like You', 'Flume', flume),
                          SongItem('Worry Bout Us', 'Rosie Lowe', rosieLowe),
                          SongItem('In the Name of Love', 'Martin Garrix', martinGarrix),
                          SongItem('In the Name of Love', 'Martin Garrix', martinGarrix),
                        ]
                    )
                ),
              ),
            ],
      ),
    );
  }
}

class SongItem extends StatelessWidget{
  final title;
  final artist;
  final image;

  SongItem(this.title, this.artist, this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (context) => DetailedScreen(title, artist, image)
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white.withOpacity(0.7),
                    size: 42.0,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: GetTextStyle.getHeadingOneTextStyle(context),
                ),
                SizedBox(height: 8.0,),
                Text(artist,
                  style: GetTextStyle.getSubHeaderTextStyle(context),
                )
              ],
            ),
            Spacer(),
            Icon(
              Icons.more_vert,
              color: Theme.of(context).textTheme.caption.color.withOpacity(0.3),
              size: 32.0,
            )
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget{
  const CustomTextField({
    Key key,
  }): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.16),
      child: Row(
        children: <Widget>[
          SizedBox( width: 8.0,),
          Icon(
            Icons.search,
            color: Colors.white,
          ),
          SizedBox(width: 8.0,),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search music...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none
              ),
            ),
          ),
          SizedBox(width: 8.0,),
          Icon(
            Icons.mic,
            color: Colors.white,
          ),
          SizedBox(width: 8.0,)
        ],
      ),
    );
  }


}

class DetailedScreen extends StatelessWidget{
  final title;
  final artist;
  final image;

  DetailedScreen(this.title, this.artist, this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: Column(
        children: <Widget>[
          Container(
            height: 500.0,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover
                    )
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [blueColor.withOpacity(0.4), blueColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 52.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              //borderRadius: BorderRadius.circular(50.0)
                            ),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'IDC Music', 
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              Text('Best music',
                                style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          Icon(
                            Icons.cloud_download,
                            color: Colors.white,
                          )
                        ],
                      ),
                      Spacer(),
                      Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0)),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        artist,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 18.0),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 42.0,),
          Slider(
            onChanged: (double value){

            },
            value: 0.2,
            activeColor: pinkColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '2:10', 
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                Text(
                  '-03:56',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                )
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.fast_rewind,
                color: Colors.white54,
                size: 42.0,
              ),
              SizedBox(width: 32.0),
              Container(
                  decoration: BoxDecoration(
                      color: pinkColor,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.play_arrow,
                      size: 58.0,
                      color: Colors.white,
                    ),
                  )),
              SizedBox(width: 32.0),
              Icon(
                Icons.fast_forward,
                color: Colors.white54,
                size: 42.0,
              )
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.bookmark_border,
                color: pinkColor,
              ),
              Icon(
                Icons.shuffle,
                color: pinkColor,
              ),
              Icon(
                Icons.repeat,
                color: pinkColor,
              ),
            ],
          ),
          SizedBox(height: 58.0),
        ],
      ),
    );
  }
}

class itemCollection extends StatelessWidget{
  final String imagePath;
  final title;

  const itemCollection({Key key, @required this.imagePath, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Utils.image(imagePath, height: 140.0, width: 180.0,fit: BoxFit.cover,),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: InkWell(
              onTap: null,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (Provider.of<AppModel>(context).theme == Themes.black || Provider.of<AppModel>(context).theme == Themes.dark)? Colors.white : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GetTextStyle.getThirdHeading(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

