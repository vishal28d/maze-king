import 'package:get/get.dart';
import 'package:maze_king/data/models/transaction_history/deposit_transaction/deposit_transaction_model.dart';
import 'package:maze_king/data/models/transaction_history/withdraw_transaction/withdraw_transaction_model.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/contests_screen_controller/contests_screen_controller.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/deposits_screen/deposit_screen_controller.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/tds_transactions_screen/tds_transactions_screen_controller.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/withdrawals_screen/withdrawals_screen_controller.dart';

import '../../data/models/transaction_history/contest_transaction/contest_transaction_model.dart';
import '../../data/models/transaction_history/tds_transaction/tds_transaction.dart';
import '../../exports.dart';

class TransactionRepository {
  /// ***********************************************************************************
  ///                             CONTEST TRANSACTION HISTORY
  /// ***********************************************************************************

  static Future<dynamic> contestTransactionAPI({RxBool? isLoader}) async {
    final ContestsScreenController con = Get.find<ContestsScreenController>();
    try {
      isLoader?.value = true;

      await APIFunction.getApiCall(apiName: ApiUrls.contestTransactionURL, params: {
        "page": con.page.value,
        "limit": con.itemLimit.value,
      }).then(
        (response) async {
          // log(jsonEncode(response));
          if (response != null && response['success'] == true) {
            final ContestTransactionDataModel contestTransactionModel = ContestTransactionDataModel.fromJson(response['data']);

            if (contestTransactionModel.results != null) {
              List<ContestTransactionModel> tempContestList = contestTransactionModel.results ?? [];

              /* /// ADD JOIN CONTEST WHERE CONTEST IS REFUNDED
              List<ContestTransactionModel> refundContestList = tempContestList.where((element) => element.isRefund == true).toList();
              for (var e in refundContestList) {
                int refundIndex = tempContestList.indexWhere((element) => element.id == e.id);
                ContestTransactionModel model = ContestTransactionModel(
                  createdAt: tempContestList[refundIndex].createdAt,
                  id: tempContestList[refundIndex].id,
                  isRefund: false,
                  joiningAmount: tempContestList[refundIndex].joiningAmount,
                  offerAmount: tempContestList[refundIndex].offerAmount,
                  refundAmount: 0,
                  winningAmount: tempContestList[refundIndex].winningAmount,
                );
                tempContestList.insert(refundIndex + 1, model);
              }*/

              /// ADD
              con.contestTransactionList.addAll(tempContestList);

              con.page.value++;
              con.nextPageAvailable.value = (contestTransactionModel.page ?? 0) < (contestTransactionModel.totalPages ?? 0);

              isLoader?.value = false;
              return con.contestTransactionList;
            }
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getContestTransactionHistory", errText: e);
    }
  }

  /// ***********************************************************************************
  ///                             DEPOSIT TRANSACTION HISTORY
  /// ***********************************************************************************

  static Future<dynamic> depositTransactionAPI({RxBool? isLoader}) async {
    final DepositScreenController con = Get.find<DepositScreenController>();
    try {
      isLoader?.value = true;

      await APIFunction.getApiCall(apiName: ApiUrls.depositTransactionURL, params: {
        "page": con.page.value,
        "limit": con.itemLimit.value,
      }).then(
        (response) async {
          if (response != null && response['success'] == true) {
            // log(response['message']+ "withdraw" );
            final DepositTransactionModel depositTransactionModel = DepositTransactionModel.fromJson(response['data']);

            if (depositTransactionModel.results != null) {
              con.depositTransactionList.addAll(depositTransactionModel.results ?? []);

              con.page.value++;
              con.nextPageAvailable.value = (depositTransactionModel.page ?? 0) < (depositTransactionModel.totalPages ?? 0);

              isLoader?.value = false;
              return con.depositTransactionList;
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

  /// ***********************************************************************************
  ///                             WITHDRAW TRANSACTION HISTORY
  /// ***********************************************************************************

  static Future<dynamic> withdrawTransactionAPI({RxBool? isLoader}) async {
    final WithdrawalsScreenController con = Get.find<WithdrawalsScreenController>();
    try {
      isLoader?.value = true;

      await APIFunction.getApiCall(apiName: ApiUrls.withdrawTransactionURL, params: {
        "page": con.page.value,
        "limit": con.itemLimit.value,
      }).then(
        (response) async {
          if (response != null && response['success'] == true) {
            // log(jsonEncode(response));
            final WithdrawTransactionModel withdrawTransactionModel = WithdrawTransactionModel.fromJson(response['data']);

            if (withdrawTransactionModel.results != null) {
              con.withdrawTransactionList.addAll(withdrawTransactionModel.results ?? []);

              con.page.value++;
              con.nextPageAvailable.value = (withdrawTransactionModel.page ?? 0) < (withdrawTransactionModel.totalPages ?? 0);

              isLoader?.value = false;
              return con.withdrawTransactionList;
            }
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getWithdrawalsTransactionHistory", errText: e);
    }
  }

  /// ***********************************************************************************
  ///                             TDS TRANSACTION HISTORY
  /// ***********************************************************************************

  static Future<dynamic> tdsTransactionAPI({RxBool? isLoader}) async {
    final TdsTransactionsScreenController con = Get.find<TdsTransactionsScreenController>();
    try {
      isLoader?.value = true;

      await APIFunction.getApiCall(apiName: ApiUrls.tdsTransactionURL, params: {
        "page": con.page.value,
        "limit": con.itemLimit.value,
      }).then(
        (response) async {
          if (response != null && response['success'] == true) {
            // log(jsonEncode(response));
            final TdsTransactionDataModel model = TdsTransactionDataModel.fromJson(response['data']);

            if (model.results != null) {
              con.transactionList.addAll(model.results ?? []);

              con.page.value++;
              con.nextPageAvailable.value = (model.page ?? 0) < (model.totalPages ?? 0);

              isLoader?.value = false;
              return con.transactionList;
            }
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "tdsTransactionAPI", errText: e);
    }
  }
}
