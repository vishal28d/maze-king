import 'package:get/get.dart';
import 'package:maze_king/data/models/winners/winners_model.dart';
import 'package:maze_king/views/winners/winners_screen_controller.dart';

import '../../exports.dart';

class WinnersRepository {
  /// ***********************************************************************************
  ///                                ALL WINNERS
  /// ***********************************************************************************

  static Future<dynamic> allWinnersAPI({
    RxBool? isLoader,
    bool isInitial = true,
    bool isPullToRefresh = false,
  }) async {
    final WinnersScreenController con = Get.find<WinnersScreenController>();
    try {
      isLoader?.value = true;
      if (isInitial) {
        if (!isPullToRefresh) {
          con.allWinners.clear();
        }
        con.page.value = 1;
        con.nextPageAvailable.value = true;
      }
      await APIFunction.getApiCall(apiName: ApiUrls.winnersURL, params: {
        "page": con.page.value,
        "limit": con.itemLimit.value,
      }).then(
        (response) async {
          // log(jsonEncode(response));
          if (response != null && response['success'] == true) {
            final WinnersModel winnersModel = WinnersModel.fromJson(response['data']);
            if (winnersModel.results != null && winnersModel.results!.isNotEmpty) {
              if (isPullToRefresh) {
                con.allWinners.value = winnersModel.results ?? [];
              } else {
                con.allWinners.addAll(winnersModel.results ?? []);
              }

              con.page.value++;
              con.nextPageAvailable.value = (winnersModel.page ?? 0) < (winnersModel.totalPages ?? 0);

              isLoader?.value = false;
              return con.allWinners;
            }
            isLoader?.value = false;
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "allWinnersAPI", errText: e);
    }
  }
}
