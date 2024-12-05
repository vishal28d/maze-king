import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/bank/get_bank_detail_model.dart';
import 'package:maze_king/data/models/wallet/wallet_model.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/repositories/wallet/wallet_repository.dart';

import '../../../../data/models/TDS/tds_details_model.dart';

class WithdrawScreenController extends GetxController {
  RxBool isLoader = false.obs;
  RxBool isLoading = false.obs;
  Rx<WalletModel> walletModel = WalletModel().obs;
  Rx<BankModel> bankModel = BankModel().obs;
  Rx<TdsTransactionModel> tdsDetailsModel = TdsTransactionModel().obs;

  Rx<TextEditingController> amountCon = TextEditingController(text: "").obs;
  RxDouble minWithdrawalAmount = 100.0.obs;
  RxDouble maxWithdrawalAmount = 700000.0.obs;
  RxDouble amount = 0.0.obs;
  RxString amountError = "".obs;
  RxBool amountHasError = true.obs;

  Timer? debounceTimer;

  num get withdrawalAmount => num.tryParse(amountCon.value.text) ?? 0;

  num get totalTds => (num.tryParse(amountCon.value.text.toString()) ?? 0) * ((isValZero(walletModel.value.tdsPercentage) ? 0 : ((walletModel.value.tdsPercentage ?? 0) / 100)));

  num get receivableAmount => (num.tryParse(amountCon.value.text) ?? 0) - totalTds;

  validate() {
    amountError.value = "";
    amountHasError.value = false;
    double enteredAmount = double.tryParse(amountCon.value.text) ?? 0;
    if (amountCon.value.text.trim().isEmpty) {
      amountError.value = "Minimum ${AppStrings.rupeeSymbol}${minWithdrawalAmount.value}";
      amountHasError.value = true;
    }
    /* else if (enteredAmount > maxWithdrawalAmount) {
      amountError.value = "Max withdrawal amount limit is ${AppStrings.rupeeSymbol}$maxWithdrawalAmount";
      amountHasError.value = true;
    }*/
    else if (enteredAmount < minWithdrawalAmount.value) {
      amountError.value = "min withdrawal amount limit is ${AppStrings.rupeeSymbol}${minWithdrawalAmount.value}";
      amountHasError.value = true;
    } else if (enteredAmount > amount.value) {
      amountError.value = "Withdrawal amount can't be greater than winning amount";
      amountHasError.value = true;
    } else {
      // amountError.value = "Minimum ${AppStrings.rupeeSymbol}$minWithdrawalAmount";
      // amountHasError.value = true;
    }
  }

  @override
  void onReady() {
    super.onReady();

    WalletRepository.getWalletDetailsAPI(isLoader: isLoader, walletType: WalletType.withdraw).then((value) {
      amount.value = (walletModel.value.winnings ?? 0).toDouble();
      if (walletModel.value.accountDetails?.accountNumber == null) {
        UiUtils.toast(AppStrings.completeYourKyc);
        Get.back();
      }
      minWithdrawalAmount.value = double.tryParse(walletModel.value.minWithdrawAmount.toString()) ?? 100;
      amountError.value = ""
          "Minimum ${AppStrings.rupeeSymbol}${minWithdrawalAmount.value}";
    });

    // BankRepository.getBankDetailsAPI(isLoader: isLoader, isWithdraw: true).then(
    //   (response) {
    //     bankModel.value = BankModel.fromJson(response['data']);
    //   },
    // );
  }
}
