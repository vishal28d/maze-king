import 'package:get/get.dart';
import 'package:maze_king/data/models/comparison/comparison_model.dart';
import 'package:maze_king/views/winners/widgets/winners_comparison_screen_controller.dart';

import '../../exports.dart';

class ComparisonRepository {
  /// ***********************************************************************************
  ///                                Comparison
  /// ***********************************************************************************

  static Future<dynamic> comparisonAPI({RxBool? isLoader,required String userId}) async {
    final WinnersComparisonScreenController con = Get.find<WinnersComparisonScreenController>();
    try {
      isLoader?.value = true;

      await APIFunction.getApiCall(
        apiName:ApiUrls.comparisonUrl(userId: userId)
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            /// temporary
            // Map<String, dynamic> response = {
            //   "success": true,
            //   "data": {
            //     "you": {"user_name": "den", "createdAt": "2024-03-18T09:11:29.289Z", "skill_score": 66.67, "winning_ratio": 66.67, "contest": 1, "image": "${LocalStorage.userImage}"},
            //     "otherUser": {"user_name": "kishan", "createdAt": "2024-03-18T09:05:47.280Z", "skill_score": 100, "winning_ratio": 100, "contest": 1, "image": "http://139.59.4.75:7002/default/user_image.jpg"}
            //   }
            // };

            final ComparisonModel comparisonModel = ComparisonModel.fromJson(response['data']);

            if (comparisonModel.you != null || comparisonModel.otherUser != null) {
              con.compare.value = comparisonModel;

              isLoader?.value = false;
              return con.compare.value;
            }
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getDepositTransactionHistory", errText: e);
    }
  }
}
