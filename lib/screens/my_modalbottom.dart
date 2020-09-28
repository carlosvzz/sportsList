import 'package:flutter/material.dart';
import 'package:XSports/models/custom_menu.dart';
import 'package:XSports/widgets/custom_icons.dart';

class MyModalBottom extends StatelessWidget {
  final Function fnSetSport;
  MyModalBottom(this.fnSetSport);

  static final List<CustomMenu> _listMenuData = [
    // Europe Extras
    //new CustomMenu('Soccer HOL', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer POR', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer HOL2', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer ENGL1', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer ENGL2', CustomIcons.soccer_ball),

    // Europe Second
    //new CustomMenu('Soccer ENG2', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer GER2', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer ESP2', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer ITA2', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer FRA2', CustomIcons.soccer_ball),

    // Europe Main
    //new CustomMenu('Soccer ENG', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer GER', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer ESP', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer ITA', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer FRA', CustomIcons.soccer_ball),

    // MEX & MLS & ESP
    new CustomMenu('', CustomIcons.baseball),
    new CustomMenu('Soccer CHAMP', CustomIcons.soccer_ball),
    new CustomMenu('', CustomIcons.baseball),
    new CustomMenu('Soccer EUR', CustomIcons.soccer_ball),
    new CustomMenu('', CustomIcons.baseball),
    //new CustomMenu('Soccer MLS', CustomIcons.soccer_ball),
    //new CustomMenu('Soccer MEX', CustomIcons.soccer_ball),
    // US Sports
    new CustomMenu('NBA', CustomIcons.dribbble),
    new CustomMenu('NHL', CustomIcons.hockey),
    new CustomMenu('MLB', CustomIcons.baseball),
    new CustomMenu('NFL', CustomIcons.football),
    new CustomMenu('NCAAF', CustomIcons.football),
    //new CustomMenu('', CustomIcons.baseball),
    //new CustomMenu('', CustomIcons.baseball),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 210,
        child: new GridView.count(
            crossAxisCount: 5,
            childAspectRatio: 1.0,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            children: _listMenuData.map((CustomMenu data) {
              return new GridTile(
                child: new SportContainer(fnSetSport: fnSetSport, data: data),
              );
            }).toList()),
      ),
    );
  }
}

class SportContainer extends StatelessWidget {
  final Function fnSetSport;
  final CustomMenu data;

  const SportContainer({
    @required this.fnSetSport,
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.nombre.isEmpty) {
      return Container();
    } else {
      return Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FlatButton(
            padding: EdgeInsets.all(0),
            child: Text(
              '${data.nombre}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17.0, color: Theme.of(context).accentColor),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await fnSetSport(data.nombre, data.icono);
            },
          ));
    }
  }
}
