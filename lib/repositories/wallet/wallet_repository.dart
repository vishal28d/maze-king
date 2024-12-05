import 'package:get/get.dart';
import 'package:maze_king/data/models/wallet/wallet_model.dart';
import 'package:maze_king/views/profile/widgets/add_cash_screen/add_cash_screen_controller.dart';
import 'package:maze_king/views/profile/widgets/wallet_screen/wallet_screen_controller.dart';
import 'package:maze_king/views/profile/widgets/withdraw_screen/withdraw_screen_controller.dart';

import '../../data/models/TDS/tds_details_model.dart';
import '../../exports.dart';

enum WalletType { wallet, addCash, withdraw }

class WalletRepository {
  /// ***********************************************************************************
  ///                              GET WALLET DETAILS
  /// ***********************************************************************************

  static Future<WalletModel?> getWalletDetailsAPI({bool isWalletFlow = false, RxBool? isLoader, WalletType? walletType}) async {
    try {
      isLoader?.value = true;

      return await APIFunction.getApiCall(apiName: ApiUrls.walletUrl).then(
        (response) async {
          if (response != null && response['success'] == true) {
            isLoader?.value = false;

            WalletModel walletModel = WalletModel.fromJson(response['data']);

            LocalStorage.storeUserDetails(myBALANCE: walletModel.myBalance);

            if (walletType == WalletType.wallet) {
              final WalletScreenController con = Get.find<WalletScreenController>();

              con.walletModel.value = walletModel;
            } else if (walletType == WalletType.addCash) {
              final AddCashScreenController con = Get.find<AddCashScreenController>();

              con.walletModel.value = walletModel;
            } else if (walletType == WalletType.withdraw) {
              final WithdrawScreenController con = Get.find<WithdrawScreenController>();

              con.walletModel.value = walletModel;
            } else {
              return walletModel;
            }

            isLoader?.value = false;
            return walletModel;
          }
          isLoader?.value = false;
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getWalletAPI", errText: e);
      return null;
    }
  }

  static Future<GetTdsDetailsModel?> getTdsCalculationDetailsAPI({RxBool? isLoader, required num amount}) async {
    try {
      isLoader?.value = true;

      return await APIFunction.postApiCall(
        apiName: ApiUrls.getTdsCalculationByAmountPOST,
        body: {
          "amount": amount,
        },
      ).then(
        (response) async {
          if (response != null) {
            GetTdsDetailsModel getTdsDetailsModel = GetTdsDetailsModel.fromJson(response);

            if (isRegistered<WithdrawScreenController>()) {
              final WithdrawScreenController con = Get.find<WithdrawScreenController>();
              if (getTdsDetailsModel.data != null) {
                con.tdsDetailsModel.value = getTdsDetailsModel.data!;
              }
            }

            isLoader?.value = false;
            return getTdsDetailsModel;
          }
          isLoader?.value = false;
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getTdsCalculationDetailsAPI", errText: e);
      return null;
    }
  }
}
