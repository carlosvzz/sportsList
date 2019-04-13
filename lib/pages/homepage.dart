import 'package:flutter/material.dart';
import 'package:sports_list/widgets/main_drawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String actualSport;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double yourWidth = width / 10;

    void setActualSport(String valor) {
      setState(() {
        actualSport = valor;
      });
    }

    return DefaultTabController(
      length: 1,
      child: Scaffold(
          drawer: MainDrawer(setActualSport),
          appBar: AppBar(
            title: Text(actualSport ?? ''),
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            bottom: TabBar(
              indicatorColor: Colors.red,
              indicatorWeight: 2.0,
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: yourWidth, right: yourWidth),
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: "lun, 08/04",
                ),
              
              ],
            ),
          ),
          body: Container(),
          ),
    );
  }
}

  //       RaisedButton(
  //         //elevation: 0.0,
  //         onPressed: () => _selectDate(context),
  //         color: Theme.of(context).accentColor,
  //         child: Text(
  //           _formatoFecha(),
  //           style: Theme.of(context).textTheme.button,
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: new BorderRadius.circular(17.0),
  //         ),
  //       ),
  //     ],
  //   );
  // }




