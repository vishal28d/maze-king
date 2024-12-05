import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/contest/completed_contest_model.dart';
import '../../../../exports.dart';
import '../../../../repositories/contest/contest_repository.dart';

class MyCompletedMatchesController extends GetxController {
  /// Contests
  RxList<CompletedContestModel> myCompletedContests = <CompletedContestModel>[].obs;

  /// Pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 25.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;
  RxBool isLoading = false.obs;

  RxBool tabChangeLoader = false.obs;

  ///
  void manageScrollController() async {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (nextPageAvailable.value && paginationLoading.isFalse) {
            /// Pagination API
            getContestsAPICall(isInitial: false, isLoader: paginationLoading);
          }
        }
      },
    );
  }

  ///
  Future<void> getContestsAPICall({bool isInitial = true, bool isPullToRefresh = false, RxBool? isLoader}) async {
    printOkStatus("getContestsAPICall");

    /// Get my live contests API
    // await ContestRepository.getMyLiveContestsAPI(isInitial: isInitial, isPullToRefresh: true, loader: isLoader);

    /// Get my completed contests API
    await ContestRepository.getMyCompletedContestsAPI(isInitial: isInitial, isPullToRefresh: isPullToRefresh, loader: isLoader);
  }

  @override
  void onReady() {
    super.onReady();
    printOkStatus("onReady-completed");

    /// Init API call
    getContestsAPICall(isLoader: isLoading);

    /// Manage scroll controller
    manageScrollController();
  }

}
