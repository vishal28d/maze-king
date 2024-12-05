import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/views/my_matches/widgets/completed/my_completed_matches_controller.dart';
import 'package:maze_king/views/my_matches/widgets/live/my_live_matches_controller.dart';
import 'package:maze_king/views/my_matches/widgets/upcoming/my_upcoming_matches_controller.dart';

import '../../exports.dart';

class MyMatchesController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    int initialIndex = Get.arguments?["initialIndex"] ?? 0;
    tabController = TabController(length: 3, vsync: this, initialIndex: initialIndex);
  }

  /// Debounce
  Rx<Timer>? debounceTimer;
  Duration debounceDuration = const Duration(milliseconds: 0);

  @override
  void onReady() {
    tabListerFunction();
    super.onReady();
  }

  void tabListerFunction() {
    tabController.addListener(
      () {
        if (tabController.indexIsChanging) {
          // printOkStatus("tab is animating. from active (getting the index) to inactive(getting the index) ");
        } else {
          /// TAB CHANGE
          switch (tabController.index) {
            case 0:
              printOkStatus("===>${tabController.index}");

              /// upcoming
              if (isRegistered<MyUpcomingMatchesController>()) {
                MyUpcomingMatchesController con = Get.find<MyUpcomingMatchesController>();
                con.getContestsAPICall(isPullToRefresh: true, isLoader: con.myUpcomingContests.isEmpty ? con.isLoading : con.tabChangeLoader);
              }

            case 1:
              printWarning("===>${tabController.index}");

              /// live
              if (isRegistered<MyLiveMatchesController>()) {
                MyLiveMatchesController con = Get.find<MyLiveMatchesController>();
                con.getContestsAPICall(isPullToRefresh: true, isLoader: con.myLiveContests.isEmpty ? con.isLoading : con.tabChangeLoader);
              }

            case 2:
              printWhite("===>${tabController.index}");

              /// completed
              if (isRegistered<MyCompletedMatchesController>()) {
                MyCompletedMatchesController con = Get.find<MyCompletedMatchesController>();
                con.getContestsAPICall(isPullToRefresh: true, isLoader: con.myCompletedContests.isEmpty ? con.isLoading : con.tabChangeLoader);
              }
          }
        }
      },
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
