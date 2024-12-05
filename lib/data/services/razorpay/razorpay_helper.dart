import 'dart:developer';
import 'package:get/get.dart';
import 'package:maze_king/data/models/razorpay/razorpay_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../exports.dart';
import '../../../utils/enums/common_enums.dart';

class RazorPayEnvironment {
  RazorPayEnvironment._();

  /// TODO
  static RazorPayEnvironmentType razorPayEnvironmentType = RazorPayEnvironmentType.production;

  static RazorPayModel keys() {
    printData(key: "API environment", value: razorPayEnvironmentType.name);

    switch (razorPayEnvironmentType) {
      case RazorPayEnvironmentType.production:
        return RazorPayModel(razorPayKey: "rzp_live_2vwOy8WMin4yYP", razorPaySecret: "PjFpHZFDq4gGpC8dr2LAh31H");

      case RazorPayEnvironmentType.test:
        return RazorPayModel(razorPayKey: "rzp_test_gNoy5ZN6gZakzO", razorPaySecret: "eliqzI4ValdXOv7dKG3ziHAr");

      case RazorPayEnvironmentType.kishanTest:
        return RazorPayModel(razorPayKey: "rzp_test_s4l7IKxTr8P2zE", razorPaySecret: "sRZSwTSnc2jcfNRxbHN9jXvb");
    }
  }
}

class RazorPayHelper {
  final Razorpay _razorpay = Razorpay();

  final razorPayKey = RazorPayEnvironment.keys().razorPayKey;
  final razorPaySecret = RazorPayEnvironment.keys().razorPaySecret;

  _initiateRazorPay({
    required Function handlePaymentSuccess,
    required Function handlePaymentError,
    required Function handleExternalWallet,
  }) {
// To handle different event with previous functions
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  /// ------------------------------ Pay by razorpay payment gateway  ----------------------------------

  void payByRazorPay({
    required RxBool loader,
    required String orderId,
    required num amount,
    required String mobileNumber,
    required Function handlePaymentSuccess,
    required Function handlePaymentError,
    required Function handleExternalWallet,
  }) {
    /// ready to pay your amount by razor pay
    _initiateRazorPay(handlePaymentSuccess: handlePaymentSuccess, handlePaymentError: handlePaymentError, handleExternalWallet: handleExternalWallet);

    var options = {
      'key': razorPayKey,
      'order_id': orderId,
      'name': AppStrings.appName,
      // 'image': AppStrings.appLogoUrl,
      "currency": "INR",
      "theme.color": "#0D1442",
      'prefill': {
        'contact': mobileNumber,
      }
    };

    /// open session
    log(options.toString());
    _razorpay.open(options);
    // loader.value = false;
  }
}

/// ------------------------------------------- HOW TO USE ----------------------------------------------------------

// void payMembershipFees({RxBool? loader}) {
//   loader?.value = true;
//
//   /// Pay By RazorPay
//   try {
//     RazorPayHelper().payByRazorPay(
//       orderId: "",
//       handlePaymentSuccess: _handlePaymentSuccess,
//       handlePaymentError: _handlePaymentError,
//       handleExternalWallet: _handleExternalWallet,
//     );
//   } catch (e) {
//     UiUtils.toast("$e");
//   } finally {
//     loader?.value = false;
//   }
// }
//
// /// ------------------------------------------- event listeners ----------------------------------------------------------
// void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   // Do something when payment succeeds
//   printOkStatus("SUCCESS");
//   printOkStatus("orderId: ${response.orderId}");
//   printOkStatus("paymentId: ${response.paymentId}");
//   printOkStatus("signature: ${response.signature}");
// }
//
// void _handlePaymentError(PaymentFailureResponse response) {
//   // Do something when payment fails
//   printError(info: "PAYMENT ERROR");
//   printError(info: "message: ${response.message}");
//   printError(info: "code: ${response.code}");
//   UiUtils.toast("PAYMENT ERROR");
// }
//
// void _handleExternalWallet(ExternalWalletResponse response) {
//   // Do something when an external wallet is selected
//   printOkStatus("EXTERNAL WALLET WAS SELECTED");
//   printOkStatus("walletName: ${response.walletName}");
// }
