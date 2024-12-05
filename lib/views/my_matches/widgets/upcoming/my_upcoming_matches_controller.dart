import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/contest/my_upcoming_contest_model.dart';
import '../../../../exports.dart';
import '../../../../repositories/contest/contest_repository.dart';
import '../../../../utils/app_remaining_time_calculator.dart';

class MyUpcomingMatchesController extends GetxController {
  /// Contests
  RxList<MyUpcomingContestModel> myUpcomingContests = <MyUpcomingContestModel>[].obs;

  /// [contestTimeList] is list of date-time of my upcoming contests
  RxList<dynamic> contestTimeList = <dynamic>[].obs;

  /// [contestRemainingTimeList] is list of remaining time of my upcoming contests
  RxList<String> contestRemainingTimeList = <String>[].obs;

  /// Pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 50.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool tabChangeLoader = false.obs;

  ///
  void manageScrollController() async {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (nextPageAvailable.value && paginationLoading.isFalse) {
            /// Pagination API
            getContestsAPICall(isInitial: false, isLoader: paginationLoading);
          }
        }
      },
    );
  }

  ///
  Future<void> getContestsAPICall({bool isInitial = true, bool isPullToRefresh = false, RxBool? isLoader}) async {
    printOkStatus("getContestsAPICall");

    /// Get my upcoming contests API
    await ContestRepository.getMyUpcomingContestsAPI(isInitial: isInitial, isPullToRefresh: isPullToRefresh, loader: isLoader);

    // await initialiseRemainingTimer();
  }

  /// Initialise Remaining Timer
  Future<void> initialiseRemainingTimer() async {
    if (timer?.isActive ?? false) timer?.cancel();
    contestTimeList.value = myUpcomingContests.map((element) => element.upcomingRemainingMilliSeconds != null ? Duration(milliseconds: element.upcomingRemainingMilliSeconds ?? 0) : element.startTime).toList();
    contestRemainingTimeList.value = List.generate(contestTimeList.length, (index) => "Wait");
    contestRemainingTimeList.refresh();

    await startUpcomingTimer();
  }

  Timer? timer;

  Future<void> startUpcomingTimer() async {
    printOkStatus("startUpcomingTimer");
    printOkStatus("START: ${contestTimeList.length} & ${contestRemainingTimeList.length}");

    Future<void> timerFunction(Timer? timer, {bool doDecrement = true, int decrementSeconds = 1}) async {
      try {
        for (int i = 0; i < contestRemainingTimeList.length; i++) {
          contestRemainingTimeList[i] = contestTimeList[i].runtimeType == DateTime
              ? AppRemainingTimeCalculator.defaultCalculation(contestTimeList[i])
              : AppRemainingTimeCalculator.getByRemainingDuration(
                  myUpcomingContests[i].startTime,
                  remainingTime: contestTimeList[i],
                  whenComplete: () {
                    if (doDecrement && contestTimeList[i].runtimeType == Duration) {
                      contestTimeList[i] = Duration(seconds: (contestTimeList[i] as Duration).inSeconds - 1);
                    }
                  },
                );

          if (contestRemainingTimeList[i].toLowerCase().trim() == "0s") {
            /// Remove item from list if it reaches its game starting time
            contestTimeList.removeAt(i);
            contestRemainingTimeList.removeAt(i);
            myUpcomingContests.removeAt(i);
            contestRemainingTimeList.refresh();

            // await getContestsAPICall(isPullToRefresh: true);
          }
        }
      } catch (e) {}
    }

    timerFunction(
      timer, /* doDecrement: false*/
    );
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        timerFunction(timer);
      },
    );
  }

  void closeTimer() {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
  }

  @override
  void onReady() {
    super.onReady();
    printOkStatus("onReady-upcoming");

    /// Init API call
    getContestsAPICall(isLoader: isLoading);

    /// Manage scroll controller
    manageScrollController();
  }

  @override
  void onClose() {
    super.onClose();
    closeTimer();
  }
}
