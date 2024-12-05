import 'dart:async';

import 'package:get/get.dart';
import 'package:maze_king/repositories/contest/contest_repository.dart';
import 'package:maze_king/views/contest_details/widgets/leaderboard/leaderboard_controller.dart';

import '../../data/models/contest/contest_details_model.dart';
import '../../exports.dart';
import '../../utils/app_remaining_time_calculator.dart';
import '../../utils/enums/contest_enums.dart';
import 'widgets/winning_board/winning_board_controller.dart';

enum ContestDetailsType {
  unJoined,
  upcoming,
  live,
  completed,
}

class ContestDetailsController extends GetxController {
  ///

  RxString contestId = "".obs;
  RxString recurringId = "".obs;
  Rx<ContestDetailsModel> contestDetailsModel = ContestDetailsModel(availableSpots: 0, entryFee: 0, maxPricePool: 0, totalSpots: 0, startTime: DateTime.now(), endTime: DateTime.now(), participateStatus: '').obs;

  ///
  RxString remainingTime = "".obs;
  RxBool isLoading = false.obs;
  RxBool buttonLoader = false.obs;

  /// contest details type
  Rx<ContestDetailsType> contestDetailsType = ContestDetailsType.unJoined.obs;

  /// update contest type enum value
  void updateContestTypeEnumByStringType(String? status) {
    switch (status) {
      case "upcoming":
        contestDetailsType.value = ContestDetailsType.upcoming;
        break;
      case "live":
        contestDetailsType.value = ContestDetailsType.live;
        break;
      case "completed":
        contestDetailsType.value = ContestDetailsType.completed;
        break;
      default:
        contestDetailsType.value = ContestDetailsType.unJoined;
    }
  }

  /// Navigation
  void navigateToCountDownScreen() {
    Get.toNamed(
      AppRoutes.gameCountdownScreen,
      arguments: {
        "contestId": contestDetailsModel.value.id.toString(),
        "recurringId": contestDetailsModel.value.recurring.toString(),
        "whenCompleteFunction": () {
          getContestDetailsAPI();
        },
      },
    )?.then((val) => getContestDetailsAPI());
  }

  ///

  Timer? timer;

  void startUpcomingTimer() {
    closeTimer(timer);
    DateTime startTime = /*DateTime.now().add(const Duration(seconds: 5))*/ contestDetailsType.value == ContestDetailsType.live ? contestDetailsModel.value.endTime : contestDetailsModel.value.startTime;
    // Duration startTimeDuration = contestDetailsType.value == ContestDetailsType.live ? Duration(milliseconds: contestDetailsModel.value.liveRemainingMilliSeconds ?? 0) : Duration(milliseconds: contestDetailsModel.value.upcomingRemainingMilliSeconds ?? 0);

    updateTimer({bool doDecrement = true, int decrementSeconds = 1}) {
      if (contestDetailsType.value == ContestDetailsType.live) {
        /// Live
        remainingTime.value = AppRemainingTimeCalculator.getByRemainingDuration(
          startTime,
          remainingTime: Duration(milliseconds: contestDetailsModel.value.liveRemainingMilliSeconds ?? 0),
          whenComplete: () {
            if (doDecrement && !isValZero(contestDetailsModel.value.liveRemainingMilliSeconds ?? 0)) {
              (contestDetailsModel.value.liveRemainingMilliSeconds = contestDetailsModel.value.liveRemainingMilliSeconds! - (decrementSeconds * 1000));
            }
          },
        );
      } else {
        if (contestDetailsModel.value.upcomingRemainingMilliSeconds != null) {
          remainingTime.value = AppRemainingTimeCalculator.getByRemainingDuration(
            startTime,
            remainingTime: Duration(milliseconds: contestDetailsModel.value.upcomingRemainingMilliSeconds ?? 0),
            whenComplete: () {
              if (doDecrement && !isValZero(contestDetailsModel.value.upcomingRemainingMilliSeconds ?? 0)) {
                contestDetailsModel.value.upcomingRemainingMilliSeconds = contestDetailsModel.value.upcomingRemainingMilliSeconds! - (decrementSeconds * 1000);
              }

              if (doDecrement && contestDetailsModel.value.liveRemainingMilliSeconds != null && !isValZero(contestDetailsModel.value.liveRemainingMilliSeconds ?? 0)) {
                (contestDetailsModel.value.liveRemainingMilliSeconds = contestDetailsModel.value.liveRemainingMilliSeconds! - (decrementSeconds * 1000));
              }
            },
          );
        } else {
          remainingTime.value = AppRemainingTimeCalculator.defaultCalculation(contestDetailsModel.value.startTime);
        }
      }
    }

    updateTimer();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        updateTimer();

        if (remainingTime.toLowerCase().trim() == "0s") {
          printOkStatus("GAME STARTS");
          closeTimer(timer);

          /// open bottom sheet according to its statuses
          // bool isJoined = contestDetailsType.value == ContestDetailsType.unJoined ? false : true;

          /*if (contestDetailsType.value == ContestDetailsType.unJoined || (contestDetailsType.value == ContestDetailsType.upcoming && Get.currentRoute == AppRoutes.contestDetailsScreen)) {
            showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                isDismissible: false,
                builder: (context) {
                  return ContestTimeOutBottomSheet(
                    isJoined: isJoined,
                    onTapOfButton: () {
                      if (isJoined) {
                        Get.back();
                        navigateToCountDownScreen();
                      } else {
                        Get.back();
                        Get.back();
                      }
                    },
                  );
                });
          }*/
        }
      },
    );
  }

  void closeTimer(Timer? timer) {
    printYellow("closeTimer");
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    printOkStatus("isActive: ${timer?.isActive}");
  }

  /// Get contest details API
  Future<void> getContestDetailsAPI({RxBool? loader, bool isPullToRefresh = false}) async {
    final WiningBoardController winingBoardController = Get.find<WiningBoardController>();
    final LeaderboardController leaderboardController = Get.find<LeaderboardController>();

    /// APIs
    await ContestRepository.getContestDetailsAPI(
      loader: loader,
      contestId: contestId.value,
      recurringId: recurringId.value,
      contestStatus: contestDetailsType.value.name == ContestDetailsType.unJoined.name ? null : contestDetailsType.value.name,
    );

    if (isPullToRefresh
        ? contestDetailsType.value.name != ContestDetailsType.completed.name
            ? true
            : (contestDetailsModel.value.contestStatus == ContestStatus.inReview.name) || (contestDetailsModel.value.contestStatus?.trim() == ContestStatus.declared.name)
        : true) {
      /// winning board
      /// Get max fill winner board API
      if (contestDetailsType.value != ContestDetailsType.completed && contestDetailsType.value != ContestDetailsType.live) {
        winingBoardController.getMaxFillWinnerBoardAPI();
      }

      /// Get current fill winner board API
      if (isRegistered<WiningBoardController>()) {
        // WiningBoardController winingBoardCon = Get.find<WiningBoardController>();
        // if (winingBoardCon.currentFillRankingList.isEmpty) {
        winingBoardController.getCurrentFillWinnerBoardAPI();
        // }
      }

      /// Get leaderboard
      if (isRegistered<LeaderboardController>()) {
        // LeaderboardController leaderboardCon = Get.find<LeaderboardController>();
        // if (contestDetailsType.value != ContestDetailsType.completed || leaderboardCon.leaderboardList.isEmpty) {
        leaderboardController.getLeaderBoardAPI(isPullToRefresh: true);
      }
    }

    /// Timer
    if (contestDetailsType.value == ContestDetailsType.completed) {
      closeTimer(timer);
    } else {
      startUpcomingTimer();
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (!isValEmpty(Get.arguments['contestDetailsType']) && Get.arguments['contestDetailsType'].runtimeType == ContestDetailsType) {
        contestDetailsType.value = Get.arguments['contestDetailsType'];
      }

      contestId.value = Get.arguments["contestId"] ?? "";
      recurringId.value = Get.arguments["recurringId"] ?? "";
    }
  }

  @override
  void onReady() {
    super.onReady();
    getContestDetailsAPI(loader: isLoading);
  }

  @override
  void onClose() {
    super.onClose();
    printOkStatus("onClose");

    closeTimer(timer);
  }
}
