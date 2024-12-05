import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../data/models/transaction_history/tds_transaction/tds_transaction.dart';
import '../../../../../../repositories/wallet/transaction_repository.dart';

class TdsTransactionsScreenController extends GetxController {
  RxBool isLoader = false.obs;
  RxList<TdsTransactionModel> transactionList = <TdsTransactionModel>[].obs;

  /// pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 50.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    TransactionRepository.tdsTransactionAPI(isLoader: isLoader);
    manageScrollController();
  }

  void manageScrollController() async {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (nextPageAvailable.value && paginationLoading.isFalse) {
            /// Pagination API
            TransactionRepository.tdsTransactionAPI(isLoader: paginationLoading);
          }
        }
      },
    );
  }
}
