import 'package:flutter/material.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/widgets/custom_icons.dart';

class MyModalBottom extends StatelessWidget {
  final Function fnSetSport;
  MyModalBottom(this.fnSetSport);

  static final List<CustomMenu> _listMenuData = [
    new CustomMenu('NBA', CustomIcons.dribbble),
    new CustomMenu('NHL', CustomIcons.hockey),
    new CustomMenu('MLB', CustomIcons.baseball),
    new CustomMenu('NFL', CustomIcons.football),
    new CustomMenu('NCAAF', CustomIcons.football),
    new CustomMenu('Soccer ENG', CustomIcons.soccer_ball),
    new CustomMenu('Soccer GER', CustomIcons.soccer_ball),
    new CustomMenu('Soccer ESP', CustomIcons.soccer_ball),
    new CustomMenu('Soccer ITA', CustomIcons.soccer_ball),
    new CustomMenu('Soccer FRA', CustomIcons.soccer_ball),
    new CustomMenu('Soccer HOL', CustomIcons.soccer_ball),
    new CustomMenu('Soccer POR', CustomIcons.soccer_ball),
    new CustomMenu('Soccer ENG2', CustomIcons.soccer_ball),
    new CustomMenu('Soccer MLS', CustomIcons.soccer_ball),
    new CustomMenu('Soccer MEX', CustomIcons.soccer_ball),
    new CustomMenu('Soccer CHAMP', CustomIcons.soccer_ball),
    new CustomMenu('Soccer EUR', CustomIcons.soccer_ball),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
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
