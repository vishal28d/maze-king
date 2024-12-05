// To parse this JSON data, do
//
//     final getPaymentIntentModel = getPaymentIntentModelFromJson(jsonString);

import 'dart:convert';

GetPaymentIntentModel getPaymentIntentModelFromJson(String str) => GetPaymentIntentModel.fromJson(json.decode(str));

String getPaymentIntentModelToJson(GetPaymentIntentModel data) => json.encode(data.toJson());

class GetPaymentIntentModel {
  final bool? success;
  final String? message;
  final GetPaymentIntentModelData? paymentIntentModelData;

  GetPaymentIntentModel({
    this.success,
    this.message,
    this.paymentIntentModelData,
  });

  factory GetPaymentIntentModel.fromJson(Map<String, dynamic> json) => GetPaymentIntentModel(
        success: json["success"],
        message: json["message"],
        paymentIntentModelData: json["data"] == null ? null : GetPaymentIntentModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": paymentIntentModelData?.toJson(),
      };
}

class GetPaymentIntentModelData {
  final int? code;
  final String? key;
  final Detail? detail;
  final PaymentIntentModel? paymentIntentModel;

  GetPaymentIntentModelData({
    this.code,
    this.key,
    this.detail,
    this.paymentIntentModel,
  });

  factory GetPaymentIntentModelData.fromJson(Map<String, dynamic> json) => GetPaymentIntentModelData(
        code: json["code"],
        key: json["key"],
        detail: json["detail"] == null ? null : Detail.fromJson(json["detail"]),
        paymentIntentModel: json["data"] == null ? null : PaymentIntentModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "key": key,
        "detail": detail?.toJson(),
        "data": paymentIntentModel?.toJson(),
      };
}

class PaymentIntentModel {
  final String? id;
  final String? externalOrderId;
  final String? epinDenomination;
  final String? paymentUrl;
  final String? successUrl;
  final String? failedUrl;
  final String? closeUrl;
  final DeliveryDetails? deliveryDetails;

  PaymentIntentModel({
    this.id,
    this.externalOrderId,
    this.epinDenomination,
    this.paymentUrl,
    this.successUrl,
    this.failedUrl,
    this.closeUrl,
    this.deliveryDetails,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) => PaymentIntentModel(
        id: json["id"],
        externalOrderId: json["external_order_id"],
        epinDenomination: json["epin_denomination"],
        paymentUrl: json["payment_url"],
        successUrl: json["success_url"],
        failedUrl: json["failed_url"],
        closeUrl: json["close_url"],
        deliveryDetails: json["delivery_details"] == null ? null : DeliveryDetails.fromJson(json["delivery_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "external_order_id": externalOrderId,
        "epin_denomination": epinDenomination,
        "payment_url": paymentUrl,
        "success_url": successUrl,
        "failed_url": failedUrl,
        "close_url": closeUrl,
        "delivery_details": deliveryDetails?.toJson(),
      };
}

class DeliveryDetails {
  final String? recipientName;
  final String? recipientEmail;
  final String? recipientPhoneNumber;
  final String? recipientPlayerId;

  DeliveryDetails({
    this.recipientName,
    this.recipientEmail,
    this.recipientPhoneNumber,
    this.recipientPlayerId,
  });

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) => DeliveryDetails(
        recipientName: json["recipient_name"],
        recipientEmail: json["recipient_email"],
        recipientPhoneNumber: json["recipient_phone_number"],
        recipientPlayerId: json["recipient_player_id"],
      );

  Map<String, dynamic> toJson() => {
        "recipient_name": recipientName,
        "recipient_email": recipientEmail,
        "recipient_phone_number": recipientPhoneNumber,
        "recipient_player_id": recipientPlayerId,
      };
}

class Detail {
  Detail();

  factory Detail.fromJson(Map<String, dynamic> json) => Detail();

  Map<String, dynamic> toJson() => {};
}
