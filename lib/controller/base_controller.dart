import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/views/bottombar/bottombar_controller.dart';
import 'package:maze_king/views/contest_details/contest_details_controller.dart';
import 'package:maze_king/views/game_countdown/game_countdown_controller.dart';
import 'package:maze_king/views/game_view_screen/game_controller.dart';
import 'package:maze_king/views/home_screen/home_controller.dart';
import 'package:maze_king/views/my_matches/my_matches_controller.dart';
import 'package:maze_king/views/my_matches/widgets/upcoming/my_upcoming_matches_controller.dart';

class BaseController extends GetxController with WidgetsBindingObserver {
  Rx<AppLifecycleState> appLifecycleState = AppLifecycleState.resumed.obs;
  final Rx<AppLifecycleState?> _previousState = AppLifecycleState.resumed.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        printOkStatus('-->  App Resumed  <-- P:${_previousState.value?.name}');
        if (_previousState.value == AppLifecycleState.paused) {
          // App is resumed from the background
          printOkStatus('ON RESUME API CALL');
          appLifecycleState.value = AppLifecycleState.resumed;

          /// TODO
          ///  game view
          gameViewOnResumeEvent();

          ///  countDown screen
          countDownScreenOnResumeEvent();

          /// home screen
          homeScreenOnResumeEvent();

          /// myGames  screen
          myGamesScreenOnResumeEvent();

          /// contest details screen
          contestDetailsScreenOnResumeEvent();
        }
        _previousState.value = state;

        break;
      case AppLifecycleState.inactive:
        // App is in an inactive state
        printOkStatus('-->  App Inactive  <--');
        appLifecycleState.value = AppLifecycleState.inactive;
        break;
      case AppLifecycleState.paused:
        // App is paused and in the background
        printOkStatus('-->  App Paused  <--');
        appLifecycleState.value = AppLifecycleState.paused;
        _previousState.value = state;

        break;
      case AppLifecycleState.detached:
        // App is detached
        printOkStatus('-->  App Detached  <--');
        appLifecycleState.value = AppLifecycleState.detached;
        break;
      case AppLifecycleState.hidden:
        // App is paused and in the hidden
        printOkStatus('-->  App hidden  <--');
        appLifecycleState.value = AppLifecycleState.hidden;
    }
  }

  /// ***********************************************************************************
  ///                                       GAME VIEW
  /// ***********************************************************************************

  /// onResume
  void gameViewOnResumeEvent() {
    printYellow("GameView OnResume Event");
    if (isRegistered<MazeGameController>()) {
      MazeGameController gameCon = Get.find<MazeGameController>();
      if (Get.currentRoute == AppRoutes.gameViewScreen && !gameCon.isFreePracticeMode.value && (gameCon.isGameFinished.value || !(gameCon.gameFinishTimer?.isActive ?? false))) {
        printErrors(type: "gameViewOnResumeEvent", errText: "GET BACK 1");
        if (!(Get.isBottomSheetOpen ?? false)) {
          gameCon.finishGameActivity();
        }
      }
    } else {
      if (Get.currentRoute == AppRoutes.gameViewScreen) {
        printErrors(type: "gameViewOnResumeEvent", errText: "GET BACK");
        Get.back();
      }
    }
  }

  /// ***********************************************************************************
  ///                                    COUNTDOWN SCREEN
  /// ***********************************************************************************

  /// onResume
  void countDownScreenOnResumeEvent() {
    printYellow("CountDown Screen OnResume Event");
    if (isRegistered<GameCountdownController>() && Get.currentRoute == AppRoutes.gameCountdownScreen) {
      GameCountdownController countdownCon = Get.find<GameCountdownController>();
      countdownCon.onInit();
    }
  }

  /// ***********************************************************************************
  ///                                       HOME SCREEN
  /// ***********************************************************************************

  /// onResume
  void homeScreenOnResumeEvent() {
    printYellow("Home Screen OnResume Event");
    if (Get.currentRoute == AppRoutes.bottomNavBarScreen && isRegistered<BottomNavBarController>() && isRegistered<HomeController>()) {
      BottomNavBarController bottomBarCon = Get.find<BottomNavBarController>();
      if (bottomBarCon.selectedScreenIndex.value == 0) {
        HomeController con = Get.find<HomeController>();
        con.onInit();
      }
    }
  }

  /// ***********************************************************************************
  ///                                      MY-GAMES SCREEN
  /// ***********************************************************************************

  /// onResume
  void myGamesScreenOnResumeEvent() {
    printYellow("MyGames Screen OnResume Event");
    if (Get.currentRoute == AppRoutes.bottomNavBarScreen && isRegistered<BottomNavBarController>() && isRegistered<MyMatchesController>()) {
      BottomNavBarController bottomBarCon = Get.find<BottomNavBarController>();
      MyMatchesController myMatchesCon = Get.find<MyMatchesController>();
      if (bottomBarCon.selectedScreenIndex.value == 1) {
        if (isRegistered<MyUpcomingMatchesController>()) {
          MyUpcomingMatchesController con = Get.find<MyUpcomingMatchesController>();
          if (myMatchesCon.tabController.index == 0) {
            con.onInit();
          }
        }
      }
    }
  }

  /// ***********************************************************************************
  ///                                     CONTEST DETAILS SCREEN
  /// ***********************************************************************************

  /// onResume
  void contestDetailsScreenOnResumeEvent() {
    printYellow("contestDetails Screen OnResume Event");
    if (Get.currentRoute == AppRoutes.contestDetailsScreen && isRegistered<ContestDetailsController>()) {
      ContestDetailsController con = Get.find<ContestDetailsController>();
      if (con.contestDetailsType.value != ContestDetailsType.completed) {
        con.onInit();
      }
    }
  }
}
