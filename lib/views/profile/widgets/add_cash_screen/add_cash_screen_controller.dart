import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';

import '../../../../data/models/wallet/wallet_model.dart';
import '../../../../repositories/wallet/wallet_repository.dart';
import '../../../../data/services/razorpay/razorpay_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddCashScreenController extends GetxController {
  Rx<WalletModel> walletModel = WalletModel().obs;
  RxBool isLoader = false.obs;

  Rx<TextEditingController> cashCon = TextEditingController(text: "50").obs;
  Function() whenCompleteFunction = () {};

  RxString cashError = ''.obs;
  RxBool cashHasError = false.obs;

  RxString cashAmount = "0".obs;

  RxList<num> amounts = [100, 200, 500].obs;

  RxBool isCurrentBalDetails = false.obs;
  RxBool isAddBalDetails = false.obs;

  void allCurrentBalDetails() {
    isCurrentBalDetails.value = !isCurrentBalDetails.value;
  }

  void allAddBalDetails() {
    isAddBalDetails.value = !isAddBalDetails.value;
  }

  RxDouble minCashDepositAmount = 100.0.obs;
  RxDouble maxCashDepositAmount = 500000.0.obs;

  validate() {
    double newValue = double.parse(cashAmount.value);
    if (cashCon.value.text.trim().isEmpty) {
      cashAmount.value = "0";
      cashHasError.value = true;
    } else if (newValue < minCashDepositAmount.value) {
      cashError.value = "Minimum limit is ${AppStrings.rupeeSymbol}${minCashDepositAmount.value}";
      cashHasError.value = true;
    } else if (newValue > maxCashDepositAmount.value) {
      cashError.value = "Maximum limit is ${AppStrings.rupeeSymbol}${maxCashDepositAmount.value}";
      cashHasError.value = true;
    } else {
      cashHasError.value = false;
    }
  }

  gstCalculation(num amount) {
    amount - (amount * (100 / (100 + 28)));
  }

  @override
  void onReady() {
    super.onReady();
    num amount = num.tryParse(cashAmount.value) ?? 0;
    if (amount < minCashDepositAmount.value) {
      validate();
    }
    initApiCall();
  }

  initApiCall() async {
    WalletModel? walletModel = await WalletRepository.getWalletDetailsAPI(isLoader: isLoader, walletType: WalletType.addCash);
    minCashDepositAmount.value = double.tryParse(walletModel!.minDepositAmount.toString()) ?? 50;
    maxCashDepositAmount.value = double.tryParse(walletModel.maxDepositAmount.toString()) ?? 500000;
      if (!(walletModel.profileVerified ?? false)) {
    String msg = "Please complete profile details first from My Info & Settings";
    Get.back();
    UiUtils.toast(msg, toastLength: Toast.LENGTH_LONG);
  }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments['money'].runtimeType == String) {
      cashCon.value.text = Get.arguments['money'].toString();
      cashAmount.value = Get.arguments['money'];
      whenCompleteFunction = Get.arguments["whenCompleteFunction"] ?? () {};
      log(cashAmount.value);
    }
  }

  /// ADD CASH FROM RAZORPAY
  void addCashPaymentRazorpayPG({required RxBool loader, required String orderId, required num amount, required String mobileNumber}) {
    loader.value = true;

    /// Pay By RazorPay
    try {
      RazorPayHelper().payByRazorPay(
        mobileNumber: mobileNumber,
        loader: loader,
        orderId: orderId,
        amount: amount,
        handlePaymentSuccess: _handlePaymentSuccess,
        handlePaymentError: _handlePaymentError,
        handleExternalWallet: _handleExternalWallet,
      );
    } catch (e) {
      // loader.value = false;

      UiUtils.toast("$e");
    } finally {
      // loader?.value = false;
    }
  }

  /// ADD CASH FROM BUSTTO
  void addCashPaymentBusttoPG({required RxBool loader, required String orderId, required num amount, required String mobileNumber}) {
    loader.value = true;

    /// Pay By RazorPay
    try {
      RazorPayHelper().payByRazorPay(
        mobileNumber: mobileNumber,
        loader: loader,
        orderId: orderId,
        amount: amount,
        handlePaymentSuccess: _handlePaymentSuccess,
        handlePaymentError: _handlePaymentError,
        handleExternalWallet: _handleExternalWallet,
      );
    } catch (e) {
      // loader.value = false;

      UiUtils.toast("$e");
    } finally {
      // loader?.value = false;
    }
  }

  /// ------------------------------------------- event listeners ----------------------------------------------------------
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    printOkStatus("SUCCESS");
    printOkStatus("orderId: ${response.orderId}");
    printOkStatus("paymentId: ${response.paymentId}");
    printOkStatus("signature: ${response.signature}");
    UiUtils.toast("Successfully Added");
    WalletRepository.getWalletDetailsAPI(isLoader: isLoader, walletType: WalletType.addCash).then(
      (value) {
        isLoader.value = false;
        Get.back();
        whenCompleteFunction();
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    printError(info: "PAYMENT ERROR");
    printError(info: "message: ${response.message}");
    printError(info: "code: ${response.code}");
    UiUtils.toast("PAYMENT FAILED");
    WalletRepository.getWalletDetailsAPI(isLoader: isLoader, walletType: WalletType.addCash).then(
      (value) {
        isLoader.value = false;
        // Get.back();
      },
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    printOkStatus("EXTERNAL WALLET WAS SELECTED");
    printOkStatus("walletName: ${response.walletName}");
    WalletRepository.getWalletDetailsAPI(isLoader: isLoader, walletType: WalletType.addCash).then(
      (value) {
        isLoader.value = false;
        Get.back();
        whenCompleteFunction();
      },
    );
  }
}
