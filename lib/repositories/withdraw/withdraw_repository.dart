import 'package:get/get.dart';
import 'package:maze_king/repositories/wallet/wallet_repository.dart';

import '../../data/models/TDS/tds_details_model.dart';
import '../../exports.dart';

class WithdrawRepository {
  /// ***********************************************************************************
  ///                              WITHDRAW AMOUNT
  /// ***********************************************************************************

  static withdrawAmountAPI({RxBool? isLoader, required num amount, required TdsTransactionModel tdsDetailsModel}) async {
    try {
      isLoader?.value = true;

      await APIFunction.postApiCall(
        apiName: ApiUrls.withdrawURL,
        body: {
          // "amount": amount,
          "withdraw": tdsDetailsModel.withdraw,
          "payoutAmount": tdsDetailsModel.payoutAmount,
          "tdsDeduct": tdsDetailsModel.tdsDeduct,
          "tdsAmount": tdsDetailsModel.tdsAmount,
          "available_un_utilized": tdsDetailsModel.availableUnUtilized,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            isLoader?.value = false;
            String msg = response['data']?['detail']?['msg'] ?? (response['message'] ?? "Please try later!");
            UiUtils.toast(msg);
            await WalletRepository.getWalletDetailsAPI();
            Get.back();
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "withdrawWinnings", errText: "$e");
    }
  }
}
