import 'package:get/get.dart';
import 'package:maze_king/data/models/comparison/comparison_model.dart';
import 'package:maze_king/data/models/winners/winners_model.dart';
import 'package:maze_king/repositories/winners/comparison_repository.dart';

class WinnersComparisonScreenController extends GetxController {
  RxBool isLoader = false.obs;

  Rx<ComparisonModel> compare = ComparisonModel().obs;
  Rx<Result> winnerDetail = Result().obs;

  @override
  void onReady() {
    super.onReady();

    if (Get.arguments != null) {
      if (Get.arguments["userId"].runtimeType == String) {
        ComparisonRepository.comparisonAPI(
          isLoader: isLoader, userId:Get.arguments["userId"]
        );
      }
    }
  }
}
