import 'package:get/get.dart';
import 'package:maze_king/repositories/contest/winningboard_repository.dart';

import '../../contest_details_controller.dart';

class WiningBoardController extends GetxController {
  final ContestDetailsController mainCon = Get.find<ContestDetailsController>();

  RxInt selectedIndex = 0.obs;
  RxList tabList = ["Max Fill", "Current Fill"].obs;

  RxBool isLoading = false.obs;

  RxList<Map<String, int>> maxFillRankingList = <Map<String, int>>[].obs;
  RxList<Map<String, int>> currentFillRankingList = <Map<String, int>>[].obs;

  RxList<Map<String, int>> get rankingList => selectedIndex.value == 0 ? maxFillRankingList : currentFillRankingList;

  @override
  void onReady() {
    super.onReady();

    /// Get max fill winner board API
    if (mainCon.contestDetailsType.value != ContestDetailsType.completed && mainCon.contestDetailsType.value != ContestDetailsType.live) {
      // getMaxFillWinnerBoardAPI(loader: isLoading);
    } else {
      selectedIndex.value = 1;
    }

    /// Get current fill winner board API
    getCurrentFillWinnerBoardAPI(loader: isLoading);
  }

  Future<dynamic> getMaxFillWinnerBoardAPI({RxBool? loader}) async {
    return await WinningBoardRepository.getMaxFillWinnerBoardAPI(entryFee: mainCon.contestDetailsModel.value.entryFee, totalSpots: mainCon.contestDetailsModel.value.totalSpots, loader: isLoading);
  }

  Future<dynamic> getCurrentFillWinnerBoardAPI({RxBool? loader}) async {
    if ((mainCon.contestDetailsModel.value.totalSpots - mainCon.contestDetailsModel.value.availableSpots) > 3) {
      return await WinningBoardRepository.getCurrentFillWinnerBoardAPI(entryFee: mainCon.contestDetailsModel.value.entryFee, totalSpots: mainCon.contestDetailsModel.value.totalSpots, filledSpots: mainCon.contestDetailsModel.value.totalSpots - mainCon.contestDetailsModel.value.availableSpots, loader: isLoading);
    }
  }
}
