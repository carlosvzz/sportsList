import 'package:flutter/material.dart';
import 'package:sports_list/screens/filters/widgets/filter_main_container.dart';
import 'package:sports_list/screens/filters/widgets/filter_my_appbart.dart';
// import 'package:provider/provider.dart';

class ScreenFilterHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilterMyAppBar(),
      // drawer: MainDrawer(),
      //bottomNavigationBar: MyBottomBar(),
      body: FilterMainContainer(),
    );
  }
}
