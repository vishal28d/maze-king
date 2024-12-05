import 'package:get/get.dart';
import '../../data/models/bustto_payment_gateway/payment_intent_model.dart';
import '../../exports.dart';

class AddCashRepository {
  /// ***********************************************************************************
  ///                              CREATE PAYMENT INTENT - RAZORPAY
  /// ***********************************************************************************

  Future<Map?> createOrderAPI({RxBool? isLoader, required num amount}) async {
    try {
      isLoader?.value = true;

      return await APIFunction.postApiCall(
        apiName: ApiUrls.createOrderURL,
        body: {"amount": amount},
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            return {
              'orderId': response['data']['id'],
              'amount': response['data']['amount'],
            };
          }

          return {
            'orderId': response['data']['id'],
            'amount': response['data']['amount'],
          };
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: this, errText: "$e");
      return null;
    }
  }

  /// ***********************************************************************************
  ///                              CREATE PAYMENT INTENT - BUSTTO
  /// ***********************************************************************************

  Future<PaymentIntentModel?> createPaymentIntentOfBusttoPgAPI({RxBool? isLoader, required num amount}) async {
    // try {
      isLoader?.value = true;

      return await APIFunction.postApiCall(
        apiName: ApiUrls.paymentIdInitiateOfBusttoPG,
        body: {"amount": amount.toString()},
      ).then(
        (response) async {
          if (response != null) {
            GetPaymentIntentModel model = GetPaymentIntentModel.fromJson(response);
            isLoader?.value = false;
            return model.paymentIntentModelData?.paymentIntentModel;
          } else {
            isLoader?.value = false;
            return null;
          }
        },
      );
    // } catch (e) {
    //   isLoader?.value = false;
    //   printErrors(type: this, errText: "$e");
    //   return null;
    // }
  }
}
