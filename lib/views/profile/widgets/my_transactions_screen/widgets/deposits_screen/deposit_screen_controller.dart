import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../data/models/transaction_history/deposit_transaction/deposit_transaction_model.dart';
import '../../../../../../repositories/wallet/transaction_repository.dart';

enum DepositsTransactionType { pending, failed, successful, discount }

class DepositScreenController extends GetxController {
  RxBool isLoader = false.obs;
  RxList<Result> depositTransactionList = <Result>[].obs;

  /// pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 50.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    TransactionRepository.depositTransactionAPI(isLoader: isLoader);
    manageScrollController();
  }

  void manageScrollController() async {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (nextPageAvailable.value && paginationLoading.isFalse) {
            /// Pagination API
            TransactionRepository.depositTransactionAPI(isLoader: paginationLoading);
          }
        }
      },
    );
  }
}
