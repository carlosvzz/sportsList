import 'package:flutter/material.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/widgets/custom_icons.dart';

class MyModalBottom extends StatelessWidget {
   final Function setSport;

   MyModalBottom(this.setSport);

   static final List<CustomMenu> _listMenuData = [
    new CustomMenu('NFL', CustomIcons.football),
    new CustomMenu('NHL', CustomIcons.hockey),
    new CustomMenu('NBA', CustomIcons.dribbble),
    new CustomMenu('MLB', CustomIcons.baseball),
    new CustomMenu('SOCCER MEX', CustomIcons.soccer_ball),
    new CustomMenu('SOCCER USA', CustomIcons.soccer_ball),
    new CustomMenu('SOCCER ESP', CustomIcons.soccer_ball),
    new CustomMenu('SOCCER GER', CustomIcons.soccer_ball),
    new CustomMenu('SOCCER ENG', CustomIcons.soccer_ball),
    new CustomMenu('SOCCER ITA', CustomIcons.soccer_ball),
    new CustomMenu('SOCCER FRA', CustomIcons.soccer_ball),
    new CustomMenu('SOCCER HOL', CustomIcons.soccer_ball),
    new CustomMenu('SOCCER POR', CustomIcons.soccer_ball),
  ];


  @override
  Widget build(BuildContext context) {
        return Container(
        height: 280,
        child: new GridView.count(
            crossAxisCount: 5,
            childAspectRatio: 1.0,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            children: _listMenuData.map((CustomMenu data) {
              return new GridTile(
                  child: Container(
        decoration: new BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FlatButton(padding: EdgeInsets.all(0), 
        child: Text('${data.nombre}', textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0, color: Theme.of(context).accentColor),), 
        onPressed: () {
          setSport(data);
          Navigator.pop(context);
          } ,) 
    ),
                  );
            }).toList()),
      );
  }
}