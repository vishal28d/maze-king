import 'package:get/get.dart';
import 'package:maze_king/data/models/game/game_details_model.dart';
import 'package:maze_king/utils/enums/contest_enums.dart';
import 'package:maze_king/views/game_countdown/game_countdown_controller.dart';

import '../../exports.dart';

class GameRepository {
  /// ***********************************************************************************
  ///                                  GET GAME DETAILS
  /// ***********************************************************************************

  static Future<GameDetailsModel?> getGameDetailsAPI({
    RxBool? loader,
    required String contestId,
    required String recurringId,
    bool isJoined = true,
  }) async {
    try {
      loader?.value = true;

      return await APIFunction.getApiCall(
        apiName: ApiUrls.getGameDetailsGET(
          contestId: contestId,
          recurringId: recurringId,
          isJoined: isJoined,
        ),
      ).then(
        (response) async {
          // log(jsonEncode(response));
          if (response != null && response['success'] == true) {
            final GetGameDetailsDataModel model = GetGameDetailsDataModel.fromJson(response);
            loader?.value = false;

            if (model.gameDetails != null) {
              if (isRegistered<GameCountdownController>()) {
                final GameCountdownController con = Get.find<GameCountdownController>();
                con.contestDetailsModel.value = model.gameDetails!;
              }
              return model.gameDetails!;
            }
          }

          loader?.value = false;
          return null;
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "getGameDetailsAPI", errText: e);
    }
    return null;
  }

  /// ***********************************************************************************
  ///                           GET FREE PRACTICE GAME SIZE
  /// ***********************************************************************************

  static Future<int?> getFreePracticeGameSizeAPI({
    RxBool? loader,
  }) async {
    try {
      loader?.value = true;

      return await APIFunction.getApiCall(
        apiName: ApiUrls.getFreePracticeGameSizeGET,
      ).then(
        (response) async {
          // log(jsonEncode(response));
          if (response != null && response['success'] == true && response['data'] != null && response['data'][0] != null) {
            loader?.value = false;
            return response['data'][0]['maze'];
          }

          loader?.value = false;
          return null;
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "getFreePracticeGameSizeAPI", errText: e);
    }
    return null;
  }

  /// ***********************************************************************************
  ///                                    START GAME
  /// ***********************************************************************************

  static Future<bool?> startGameAPI({
    RxBool? loader,
    required String contestId,
    required String recurringId,
    // required bool isNavFromDescScreen,
  }) async {
    try {
      loader?.value = true;

      return await APIFunction.postApiCall(
        apiName: ApiUrls.startGamePOST(contestId: contestId, recurringId: recurringId),
        body: {
          "join_status": "start" //start, exit
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            loader?.value = false;
            return response['success'];
          }
          loader?.value = false;
          return response['success'];
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "startGameAPI", errText: e);
    }
    loader?.value = false;
    return null;
  }

  /// ***********************************************************************************
  ///                                    FINISH GAME
  /// ***********************************************************************************

  static Future<dynamic> finishGameAPI({
    RxBool? loader,
    required String contestId,
    required String recurringId,
    required WinningStatus winningStatus,
    required String onTrackPercentage,
    required String totalPercentage,
    required num takenTimeInMicroseconds,
    // required bool isNavFromDescScreen,
  }) async {
    try {
      loader?.value = true;

      return await APIFunction.postApiCall(
        apiName: ApiUrls.finishGamePOST(contestId: contestId, recurringId: recurringId),
        body: {
          "join_status": "exit", // enums = start,exit
          "winning_status": winningStatus.name, // enums = won,lose
          "winning_percentage": onTrackPercentage,
          "total_percentage": totalPercentage,
          "winning_time": takenTimeInMicroseconds,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            loader?.value = false;
            // Get.back();
            return response;
          }
          loader?.value = false;
          return null;
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "finishGameAPI", errText: e);
    }
    return null;
  }
}
