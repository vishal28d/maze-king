import 'package:get/get.dart';
import '../../data/models/contest/winningboard_model.dart';
import '../../exports.dart';
import '../../views/contest_details/widgets/winning_board/winning_board_controller.dart';

class WinningBoardRepository {
  /// ***********************************************************************************
  ///                                GET MAX FILL WINNER BOARD
  /// ***********************************************************************************

  static Future<List<Map<String, int>>?> getMaxFillWinnerBoardAPI({
    RxBool? loader,
    required num entryFee,
    required num totalSpots,
  }) async {
    try {
      loader?.value = true;
      return await APIFunction.postApiCall(
        apiName: ApiUrls.getMaxFillWinnerBoardPOST,
        body: {
          "fee": entryFee,
          "totalUsers": totalSpots,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            GetWinningBoardDataModel model = GetWinningBoardDataModel.fromJson(response);
            if (isRegistered<WiningBoardController>()) {
              WiningBoardController con = Get.find<WiningBoardController>();
              con.maxFillRankingList.value = model.data?.ranking ?? [];
            }
            loader?.value = false;
            return model.data?.ranking;
          }
          loader?.value = false;
          return null;
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "getMaxFillWinnerBoardAPI", errText: e);
    }
    return null;
  }

  /// ***********************************************************************************
  ///                               GET CURRENT FILL WINNER BOARD
  /// ***********************************************************************************

  static Future<List<Map<String, int>>?> getCurrentFillWinnerBoardAPI({
    RxBool? loader,
    required num entryFee,
    required num totalSpots,
    required num filledSpots,
  }) async {
    try {
      loader?.value = true;
      return await APIFunction.postApiCall(
        apiName: ApiUrls.getCurrentFillWinnerBoardPOST,
        body: {
          "fee": entryFee,
          "totalUsers": totalSpots,
          "currentUsers": filledSpots,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            GetWinningBoardDataModel model = GetWinningBoardDataModel.fromJson(response);
            if (isRegistered<WiningBoardController>()) {
              WiningBoardController con = Get.find<WiningBoardController>();
              con.currentFillRankingList.value = model.data?.ranking ?? [];
            }
            loader?.value = false;
            return model.data?.ranking;
          }
          loader?.value = false;
          return null;
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "getCurrentFillWinnerBoardAPI", errText: e);
    }
    return null;
  }
}
