import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/game/game_details_model.dart';
import 'package:maze_king/repositories/game/game_repository.dart';
import 'package:maze_king/utils/enums/contest_enums.dart';
import '../../exports.dart';
import '../../utils/app_remaining_time_calculator.dart';

class GameCountdownController extends GetxController {
  RxString contestId = "".obs;
  RxString recurringId = "".obs;
  Function() whenCompleteFunction = () {};
  Rx<GameDetailsModel> contestDetailsModel = GameDetailsModel().obs;

  RxBool isLoading = false.obs;
  RxString remainingTime = "".obs;
  RxInt remainingTimeInSec = 0.obs;

  Timer? timer;

  void startUpcomingTimer() {
    closeTimer(timer);

    /// TODO
    /// Check Timer
    void timeOutActivity() {
      closeTimer(timer);
      printOkStatus("GAME STARTS");

      // printOkStatus("${contestDetailsModel.value.cells}");
      // printOkStatus("${contestDetailsModel.value.start}");
      // printOkStatus("${contestDetailsModel.value.end}");

      /// Delete GameViewController
      deleteGameViewController();

      if ((AppRemainingTimeCalculator.defaultCalculation(contestDetailsModel.value.endTime ?? DateTime.now(), showSecondsInHourFormat: true) == "0s") /*|| (contestDetailsModel.value.)*/) {
        whenCompleteFunction();
        Get.back();
      } else {
        /// If users have already played the game
        if (contestDetailsModel.value.joinStatus == JoinStatus.exit.name) {
          UiUtils.toast("You have already completed the game");
          Get.back();
        } else {
          /// Navigate to Game View
          Get.offNamed(
            AppRoutes.gameViewScreen,
            arguments: {
              "gameDetailsModel": contestDetailsModel.value,
              "whenCompleteFunction": whenCompleteFunction,
              "isFreePracticeMode": false,
              "isTestMode": kDebugMode,
            },
          );
        }
      }
    }

    ///
    DateTime startTime = /*!kDebugMode ?*/ contestDetailsModel.value.startTime ?? DateTime.now() /* : DateTime.now().add(const Duration(seconds: 1))*/;
    // Duration startTimeDuration = Duration(milliseconds: contestDetailsModel.value.upcomingRemainingMilliSeconds ?? 0);

    void updateTimer({bool doDecrement = true, int decrementSeconds = 1}) {
      if (contestDetailsModel.value.upcomingRemainingMilliSeconds != null) {
        remainingTime.value = AppRemainingTimeCalculator.getByRemainingDuration(
          startTime,
          remainingTime: Duration(milliseconds: contestDetailsModel.value.upcomingRemainingMilliSeconds ?? 0),
          whenComplete: () {
            if (doDecrement && !isValZero(contestDetailsModel.value.upcomingRemainingMilliSeconds ?? 0)) {
              contestDetailsModel.value.upcomingRemainingMilliSeconds = (contestDetailsModel.value.upcomingRemainingMilliSeconds! - (decrementSeconds * 1000));
            }
            if (doDecrement && contestDetailsModel.value.liveRemainingMilliSeconds != null && !isValZero(contestDetailsModel.value.liveRemainingMilliSeconds ?? 0)) {
              contestDetailsModel.value.liveRemainingMilliSeconds = (contestDetailsModel.value.liveRemainingMilliSeconds! - (decrementSeconds * 1000));
            }
          },
        );
      } else {
        remainingTime.value = AppRemainingTimeCalculator.defaultCalculation(startTime);
      }
    }

    ///

    /// TODO
    updateTimer(/*doDecrement: false*/);
    if (remainingTime.toLowerCase().trim() == "0s" || remainingTime.toLowerCase().trim() == "00s") {
      timeOutActivity();
    }
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        updateTimer();
        if (contestDetailsModel.value.upcomingRemainingMilliSeconds == null) {
          int remainingSec = startTime.difference(DateTime.now()).inSeconds;
          remainingTimeInSec.value = (remainingSec > 0) ? remainingSec : 0;
        } else {
          remainingTimeInSec.value = Duration(milliseconds: contestDetailsModel.value.upcomingRemainingMilliSeconds ?? 0).inSeconds;
        }
        if (remainingTime.toLowerCase().trim() == "0s" || remainingTime.toLowerCase().trim() == "00s") {
          timeOutActivity();
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
  Future<void> getGameDetailsAPI({RxBool? loader}) async {
    /// APIs
    await GameRepository.getGameDetailsAPI(
      loader: loader,
      contestId: contestId.value,
      recurringId: recurringId.value,
    );

    /// Timer
    startUpcomingTimer();
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      contestId.value = Get.arguments["contestId"] ?? "";
      recurringId.value = Get.arguments["recurringId"] ?? "";
      whenCompleteFunction = Get.arguments["whenCompleteFunction"] ?? () {};
    }
  }

  @override
  void onReady() {
    super.onReady();
    getGameDetailsAPI(loader: isLoading);
  }

  @override
  void onClose() {
    super.onClose();
    closeTimer(timer);
  }
}
