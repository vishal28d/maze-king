import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../data/models/transaction_history/withdraw_transaction/withdraw_transaction_model.dart';
import '../../../../../../repositories/wallet/transaction_repository.dart';

// enum WithdrawalsTransactionType { pending, incomplete, completed }
enum WithdrawalsTransactionType { reversed, processing, processed }

class WithdrawalsScreenController extends GetxController {
  RxBool isLoader = false.obs;
  RxList<WithdrawalTransactionModel> withdrawTransactionList = <WithdrawalTransactionModel>[].obs;

  /// pagination
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt itemLimit = 50.obs;
  RxBool nextPageAvailable = true.obs;
  RxBool paginationLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    TransactionRepository.withdrawTransactionAPI(isLoader: isLoader);
    manageScrollController();
  }

  void manageScrollController() async {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (nextPageAvailable.value && paginationLoading.isFalse) {
            /// Pagination API
            TransactionRepository.withdrawTransactionAPI(isLoader: paginationLoading);
          }
        }
      },
    );
  }
}
