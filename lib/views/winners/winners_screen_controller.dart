import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/winners/winners_model.dart';
import 'package:maze_king/repositories/winners/winners_repository.dart';

class WinnersScreenController extends GetxController {
  RxBool isLoader = false.obs;

  Rx<TextEditingController> searchCon = TextEditingController().obs;
  RxString searchError = ''.obs;
  RxBool searchHasError = false.obs;

  RxList<Result> allWinners = <Result>[].obs;

  /// pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 50.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    WinnersRepository.allWinnersAPI(isLoader: isLoader);
    manageScrollController();
  }

  void manageScrollController() async {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (nextPageAvailable.value && paginationLoading.isFalse) {
            /// Pagination API
            WinnersRepository.allWinnersAPI(isInitial: false, isLoader: paginationLoading);
          }
        }
      },
    );
  }
}
