import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maze_king/repositories/wallet/transaction_repository.dart';

import '../../../../../../data/models/transaction_history/contest_transaction/contest_transaction_model.dart';

enum ContestTransactionType { winning, offerApplied, entryPaid, refund, gameError }

class ContestsScreenController extends GetxController {
  RxBool isLoader = false.obs;
  RxList<ContestTransactionModel> contestTransactionList = <ContestTransactionModel>[].obs;

  /// pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 50.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    TransactionRepository.contestTransactionAPI(isLoader: isLoader);
    manageScrollController();
  }

  void manageScrollController() async {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (nextPageAvailable.value && paginationLoading.isFalse) {
            /// Pagination API
            TransactionRepository.contestTransactionAPI(isLoader: paginationLoading);
          }
        }
      },
    );
  }
}
