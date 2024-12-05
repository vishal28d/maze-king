import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/contest/leaderboard_model.dart';
import 'package:maze_king/repositories/contest/leaderboard_repository.dart';

import '../../contest_details_controller.dart';

class LeaderboardController extends GetxController {
  RxList<LeaderBoardModel> leaderboardList = <LeaderBoardModel>[].obs;
  Rx<LeaderBoardModel?> myLeaderboardData = LeaderBoardModel().obs;

  final ContestDetailsController con = Get.find<ContestDetailsController>();

  /// Pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 50.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;
  RxBool isLoading = false.obs;

  ///
  void manageScrollController() async {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (nextPageAvailable.value && paginationLoading.isFalse) {
            /// Pagination API
            getLeaderBoardAPI(isInitial: false, loader: paginationLoading);
          }
        }
      },
    );
  }

  @override
  void onReady() {
    super.onReady();

    /// get leaderboard API
    getLeaderBoardAPI(loader: isLoading);

    /// manage scroll controller
    manageScrollController();
  }

  /// Get get leader board API
  Future<dynamic> getLeaderBoardAPI({
    RxBool? loader,
    bool isInitial = true,
    bool isPullToRefresh = false,
  }) async {
    return await LeaderboardRepository.getLeaderBoardAPI(
      loader: loader,
      isInitial: isInitial,
      isPullToRefresh: isPullToRefresh,
      contestId: con.contestId.value,
      recurringId: con.recurringId.value,
    );
  }
}
