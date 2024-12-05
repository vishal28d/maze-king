import 'package:get/get.dart';
import 'package:maze_king/views/contest_details/widgets/leaderboard/leaderboard_controller.dart';

import '../../data/models/contest/leaderboard_model.dart';
import '../../exports.dart';

class LeaderboardRepository {
  /// ***********************************************************************************
  ///                                GET LEADER BOARD
  /// ***********************************************************************************

  static Future<dynamic> getLeaderBoardAPI({
    required bool isInitial,
    required bool isPullToRefresh,
    RxBool? loader,
    required String contestId,
    required String recurringId,
  }) async {
    if (isRegistered<LeaderboardController>()) {
      final LeaderboardController con = Get.find<LeaderboardController>();

      try {
        loader?.value = true;

        if (isInitial) {
          if (!isPullToRefresh) {
            con.leaderboardList.clear();
          }
          con.page.value = 1;
          con.nextPageAvailable.value = true;
        }

        return await APIFunction.getApiCall(
          apiName: ApiUrls.getLeaderBoardPOST(
              contestId: contestId, recurringId: recurringId),
          params: {
            "page": con.page.value,
            "limit": con.itemLimit.value,
          },
        ).then(
          (response) async {
            // log(jsonEncode(response));
            if (response != null &&
                response['data'] != null &&
                response['success'] == true) {
              GetLeaderboardDataModel model =
                  GetLeaderboardDataModel.fromJson(response);

              if (model.data != null && isRegistered<LeaderboardController>()) {
                LeaderboardController con = Get.find<LeaderboardController>();
                if (model.data!.myLeaderboardDetails != null) {
                  con.myLeaderboardData.value =
                      model.data!.myLeaderboardDetails;
                }

                if (isPullToRefresh || isInitial) {
                  /// Initial, PullToRefresh
                  con.leaderboardList.value = model.data!.leaderboardList ?? [];
                  if (!isValEmpty(model.data!.myLeaderboardDetails)) {
                    if (con.leaderboardList.isNotEmpty &&
                        con.leaderboardList[0].userId !=
                            model.data!.myLeaderboardDetails?.userId) {
                      con.leaderboardList
                          .insert(0, model.data!.myLeaderboardDetails!);
                    } else {
                      con.leaderboardList
                          .add(model.data!.myLeaderboardDetails!);
                    }
                  }
                } else {
                  /// Pagination
                  con.leaderboardList.addAll(model.data!.leaderboardList ?? []);
                }

                con.page.value++;
                con.nextPageAvailable.value =
                    (model.data!.page ?? 0) < (model.data!.totalPages ?? 0);

                loader?.value = false;
                return response;
              }
            }
            loader?.value = false;


            return null;
          },
        );
      } catch (e) {
        loader?.value = false;
        printErrors(type: "getLeaderBoardAPI", errText: e);
      }
    }
    return null;
  }
}
