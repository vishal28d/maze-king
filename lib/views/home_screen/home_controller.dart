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
  List<UpcomingContestModel> get sortedList => upcomingContests
      .where((contest) => contest.pin_to_top != null) // Filter out contests where pin_to_top is null
      .toList()
    ..sort((a, b) {
      // Check if both contests are pinned to the top
      if (a.pin_to_top == true && b.pin_to_top == true) {
        // If both are pinned, sort by top_position
        return a.top_position!.compareTo(b.top_position as num);
      } else if (a.pin_to_top == true) {
        // If only 'a' is pinned, it should come first
        return -1; // 'a' should be before 'b'
      } else if (b.pin_to_top == true) {
        // If only 'b' is pinned, it should come first
        return 1; // 'b' should be after 'a'
      } else {
        // If neither is pinned, maintain original order (or use another criteria if needed)
        return 0;
      }
    });
    // ..sort((a, b) => (b.pin_to_top == true ? 1 : 0)
    //     .compareTo(a.pin_to_top == true ? 1 : 0));

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
      for (int i = 1; i < timerList.length; i++) {
        timerList[i] = timesList[i].runtimeType == DateTime
            ? AppRemainingTimeCalculator.defaultCalculation(timesList[i])
            : AppRemainingTimeCalculator.getByRemainingDuration(
          upcomingContests[i].startTime,
          remainingTime: timesList[i],
          whenComplete: () {
            if (doDecrement && timesList[i].runtimeType == Duration) {
              timesList[i] = Duration(
                  seconds: (timesList[i] as Duration).inSeconds - 1);
            }
          },
        );

        if (timerList[i].toLowerCase().trim() == "0s") {
          /// Remove item from list if it reaches its game starting time
          timesList.removeAt(i);
          timerList.removeAt(i);
          upcomingContests.removeAt(i);
          timerList.refresh();
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
