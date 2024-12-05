import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maze_king/views/winners/winners_screen.dart';

import '../home_screen/home_screen.dart';
import '../my_matches/my_matches_screen.dart';
import '../profile/profile_screen.dart';

class BottomNavBarController extends GetxController {
  RxInt selectedScreenIndex = 0.obs;

  Widget screenViewByIndex() {
    switch (selectedScreenIndex.value) {
      case 0:
        return HomeScreen();
      case 1:
        return MyMatchesScreen();
      case 2:
        return WinnersScreen();
      case 3:
        return ProfileScreen();
      default:
        return Container();
    }
  }
}
