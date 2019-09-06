

import 'package:church_of_christ/data/models/event.dart';
import 'package:church_of_christ/data/models/news.dart';
import 'package:church_of_christ/ui/widgets/custom_page.dart';
import 'package:church_of_christ/ui/widgets/custom_tab.dart';
import 'package:church_of_christ/ui/widgets/intro_page_item.dart';
import 'package:church_of_christ/ui/widgets/page_transformer.dart';
import 'package:church_of_christ/ui/widgets/popup_settings.dart';
import 'package:church_of_christ/ui/widgets/search.dart';
import 'package:church_of_christ/ui/widgets/sliver_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class EventsScreen extends StatefulWidget{

  const EventsScreen({
    Key key,
  }) : super(key:key);

  @override
  State createState() {
    return _EventsScreen();
  }
}

class _EventsScreen extends State<EventsScreen>{

  @override
  Widget build(BuildContext context) {
    return _getScaffoldBlanckPage(context);
  }

  Widget _getScaffoldBlanckPage(BuildContext context){
    return BlanckPage.offTitle(
      //title: FlutterI18n.translate(context, 'acuedd.events.title'),
      actions: <Widget>[
        PopupSettins()
      ],
      body: Container(
        //color: Colors.grey[200],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: SearchWidget(),
              ),
              _getFiltersDate(),
              Expanded(
                child: _buildFeatureds(),
              ),

            ],
          )
      ),
    );
  }

  Widget _getScaffoldSliverBar(BuildContext context){
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        _getSliverBar(context),

      ]),
    );
  }

  Widget _getSliverBar(BuildContext context){
    return SliverBar(
      title: FlutterI18n.translate(context, 'acuedd.events.title'),
      actions: <Widget>[
        PopupSettins()
      ],
    );
  }

  Widget _getFiltersDate(){
    List<String> list = [
      FlutterI18n.translate(context, 'acuedd.events.search.comingsoon'),
      FlutterI18n.translate(context, 'acuedd.events.search.now'),
      FlutterI18n.translate(context, 'acuedd.events.search.previously'),
      FlutterI18n.translate(context, 'acuedd.events.search.memories'),
    ];
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 300),
      child: CustomTab(
        itens: list,
        tabSelected: (index){
          //TODO HERE PUT SENT TO FILTER CATEGORY
        },
      ),
    );
  }

  Widget _buildSchemeFeatureds(){
    return Stack(
      children: <Widget>[
        new Stack(
          children: <Widget>[
            new Container(
              child: _buildFeatureds(),
            )
          ],
        )
      ],
    );

  }

  Widget _buildFeatureds(){
    List _destaque = [
      myEvent(
          id: "1",
          title: "Renovación - Ciudad de Guatemala",
          description:"is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          urlImage: "https://scontent-mia3-1.xx.fbcdn.net/v/t1.0-9/69016926_2275306942782471_3157386894883422208_o.png?_nc_cat=110&_nc_oc=AQlaLexXAWuHGLDRkUBjLN_xr2wySKGbjskhLpF0BkcSfQ73Td9fZUfrz48O8nIMIAY&_nc_ht=scontent-mia3-1.xx&oh=d6140db9652f160d9ab9103442daed93&oe=5DCDA139",
          likes: 0,
          liked: true,
          date:  "hoy",
          price: 100.0,
          address: "en la esquina",
          urlFb: "",
          urlTwitter: ""
      ), myEvent(
          id: "1",
          title: "El Sembrador - Centro Histórico",
          description:"Confraternidad de jóvenes",
          urlImage: "https://scontent-mia3-2.xx.fbcdn.net/v/t1.0-9/70274598_2279271002386065_7927742912329154560_n.jpg?_nc_cat=106&_nc_oc=AQmVSWYl1vqQTct3QhjNyTx83fVDyiS7YfKgztCyaBtoX456Ho52FDuTZDbcMNoY8Is&_nc_ht=scontent-mia3-2.xx&oh=4649edfa5058a012d9a26b323eb07440&oe=5E14B111",
          likes: 0,
          liked: true,
          date:  "hoy",
          price: 100.0,
          address: "en la esquina",
          urlFb: "",
          urlTwitter: ""
      ),myEvent(
          id: "1",
          title: "Champions Conjóvenes",
          description:"Confraternidad de jóvenes",
          urlImage: "https://scontent-mia3-2.xx.fbcdn.net/v/t1.0-9/53142836_2155280034785163_8146762287097577472_o.png?_nc_cat=109&_nc_oc=AQlfA_AUEnTNo_9vxfeF-XnoozrVzNKYVFXufuA6gclTZScJB9QMY2BXM9BIx1DU7-E&_nc_ht=scontent-mia3-2.xx&oh=9b706be5ebe28b5e7fead036da4584ad&oe=5E0156CC",
          likes: 0,
          liked: true,
          date:  "hoy",
          price: 100.0,
          address: "en la esquina",
          urlFb: "",
          urlTwitter: ""
      ),myEvent(
          id: "1",
          title: "Start - Villa Hermosa",
          description:"Confraternidad de jóvenes",
          urlImage: "https://scontent-mia3-1.xx.fbcdn.net/v/t1.0-9/47389861_10213258100474425_7022580358583418880_o.jpg?_nc_cat=107&_nc_oc=AQmwDBhVEhUJfiQ9X6EZX7cO6xBfP59E6slp6Aqqofs5lYCwT_-jwYNv-ZjS-1VbQ_s&_nc_ht=scontent-mia3-1.xx&oh=fa5eddc602540dd7e4f09701d13aea9b&oe=5DFF2DBF",
          likes: 0,
          liked: true,
          date:  "hoy",
          price: 100.0,
          address: "en la esquina",
          urlFb: "",
          urlTwitter: ""
      ),myEvent(
          id: "1",
          title: "Mira a Cristo",
          description:"Confraternidad de jóvenes",
          urlImage: "https://scontent-mia3-1.xx.fbcdn.net/v/t1.0-9/48381413_10157305483420639_7961079443458359296_n.jpg?_nc_cat=109&_nc_oc=AQnccUazWdSsDKWyZ39VKiM8Am7aE320CIOogqSjyuot9GRY0GdQS-7sEvmguDBUJRI&_nc_ht=scontent-mia3-1.xx&oh=9924cc4b795ad5a75c491e166389ffb0&oe=5DC89F10",
          likes: 0,
          liked: true,
          date:  "hoy",
          price: 100.0,
          address: "en la esquina",
          urlFb: "",
          urlTwitter: ""
      ),myEvent(
          id: "1",
          title: "Si no cambias, todo se repite...",
          description:"Confraternidad de jóvenes",
          urlImage: "https://scontent-mia3-1.xx.fbcdn.net/v/t1.0-9/64536552_2452469318317920_281884244144291840_n.jpg?_nc_cat=111&_nc_oc=AQmDffNhPNZHpszQmWvt_1Mxed4cIHpB1m1lAK1b37CPbFwPP9MnTon31KQ42ds9TAM&_nc_ht=scontent-mia3-1.xx&oh=1ccd28271156f7ae8e2332360020ea43&oe=5E0BB9A9",
          likes: 0,
          liked: true,
          date:  "hoy",
          price: 100.0,
          address: "en la esquina",
          urlFb: "",
          urlTwitter: ""
      )
    ];

    var length = _destaque.length;

    Widget featured = PageTransformer(
      pageViewBuilder: (context, visibilityResolver){
        return new PageView.builder(
          controller: new PageController(viewportFraction: 0.9),
          itemCount: length,
          itemBuilder: (context, index){
            final item = IntroNews.fromNotice(_destaque[index]);
            final pageVisibility = visibilityResolver.resolvePageVisibility(index);
            return new IntroNewsItem(item: item, pageVisibility: pageVisibility);
          },
        );
      },
    );


    return AnimatedOpacity(
      opacity: length > 0 ? 1: 0,
      duration: Duration(milliseconds: 300),
      child: featured,
    );

  }
}