import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/contest/upcoming_contest_model.dart';
import '../../exports.dart';
import '../../repositories/contest/contest_repository.dart';
import '../../utils/app_remaining_time_calculator.dart';

class HomeController extends GetxController {
  /// CONTEST
  RxList<UpcomingContestModel> upcomingContests = <UpcomingContestModel>[].obs;

  final _pinnedContests = <UpcomingContestModel>[].obs;
  List<UpcomingContestModel> get pinnedContests => _pinnedContests;
  set pinnedContests(List<UpcomingContestModel> value) => _pinnedContests.value = value;

  /// Debounce
  Timer? debounceTimer;
  Duration debounceDuration = const Duration(milliseconds: 300);
  Duration debounceDurationOfInstructions = const Duration(milliseconds: 100);

  /// [timerList] is list of remaining time of upcoming contests
  RxList<String> timerList = <String>[].obs;

  /// [timesList] is list of date-time of upcoming contests
  RxList<dynamic> timesList = <dynamic>[].obs;

  /// Pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 50.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;
  RxBool isLoading = false.obs;

  RxBool userGuideLoader = false.obs;
  RxBool howToPlayLoader = false.obs;

  /// Get sorted list of upcoming contests
  List<UpcomingContestModel> get sortedList {
    // Sorting contests that are pinned and non-pinned correctly
    var pinned = upcomingContests.where((contest) => contest.pin_to_top == true).toList();
    var unpinned = upcomingContests.where((contest) => contest.pin_to_top != true).toList();

    // Sort pinned contests by top_position, and then append unpinned contests at the end
    pinned.sort((a, b) => a.top_position!.compareTo(b.top_position as num));

    return pinned + unpinned;
  }

  /// Manage scroll controller
  void manageScrollController() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        if (nextPageAvailable.value && paginationLoading.isFalse) {
          /// Pagination API
          getContestsAPICall(isInitial: false, isLoader: paginationLoading);
        }
      }
    });
  }

  /// Get contests API call
  Future<void> getContestsAPICall({bool isInitial = true, bool isPullToRefresh = false, RxBool? isLoader}) async {
    printOkStatus("getContestsAPICall");

    /// Get upcoming contests API
    await ContestRepository.getUpcomingContestsAPI(
      isInitial: isInitial,
      isPullToRefresh: isPullToRefresh,
      loader: isLoader,
    );

    /// Initialize Remaining Timer
    initialiseRemainingTimer();
  }

  /// Initialise Remaining Timer
  void initialiseRemainingTimer() {
    if (timer?.isActive ?? false) timer?.cancel();
    upcomingContests.refresh();
    timesList.value = upcomingContests
        .map((element) => element.upcomingRemainingMilliSeconds != null
            ? Duration(milliseconds: element.upcomingRemainingMilliSeconds ?? 0)
            : element.startTime)
        .toList();
    timerList.value = List.generate(timesList.length, (index) => "Wait");
    timerList.refresh();
    startUpcomingTimer();
  }

  Timer? timer;

  void startUpcomingTimer() {
    printOkStatus("startUpcomingTimer");
    printOkStatus("START: ${timesList.length} & ${timerList.length}");
    upcomingContests.refresh();
    timerList.refresh();
    
    void timerFunction(Timer? timer, {bool doDecrement = true}) {
      // Use a reverse loop to avoid index errors when removing items
      for (int i = timerList.length - 1; i >= 0; i--) {
        if (timesList[i].runtimeType == DateTime) {
          // If timesList contains DateTime objects, calculate the time left
          timerList[i] = AppRemainingTimeCalculator.defaultCalculation(timesList[i]);
        } else {
          // Handle the countdown for remaining duration
          timerList[i] = AppRemainingTimeCalculator.getByRemainingDuration(
            upcomingContests[i].startTime,
            remainingTime: timesList[i],
            whenComplete: () {
              if (doDecrement && timesList[i].runtimeType == Duration) {
                // Decrease the duration if necessary
                timesList[i] = Duration(seconds: (timesList[i] as Duration).inSeconds - 1);
              }
            },
          );
        }

        if (timerList[i].toLowerCase().trim() == "0s") {
          // Remove contest if time has reached
          upcomingContests.removeAt(i);
          timesList.removeAt(i);
          timerList.removeAt(i);
        }
      }
    }

    timerFunction(timer, doDecrement: false);
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
    printOkStatus("onReady-homeCon");

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
