import 'dart:io';

import 'package:maze_king/exports.dart';

import 'app_environment.dart';

class ApiUrls {
  static String baseUrl = AppEnvironment.getApiURL();

  /// ADDRESS
  // static String getStatesByCountry({required String countryId}) => "country/states/$countryId";
  static String getStatesByCountry({required String countryId}) => "user/state";

  /// Splash
  static String splashGET({required String versionCode}) =>
      "version/${Platform.isAndroid ? 'android' : 'iOS'}/$versionCode";

  /// Auth
  static String sendOtpByMobilePOST = "user/auth/send-otp";
  static String verifyMobileOtpPOST = "user/auth/verify-otp";

  static String loginPOST = "user/auth/login";
  static String registerPOST = "user/auth/register";
  static String checkUserExistOrNotGET = "user/check-exist-user/";
  static String verifyReferralCodePOST = "user/verify-referral/";
  static String addUserNameInAuthPOST = "user/auth/username";
  static String logOutPOST = "user/auth/logout";
  static String deleteAccountDELETE = "user/auth";

  /// contest
  static String getUpcomingContestsGET = "user/contest/list";

  static String getContestDetailsGET(
          {required String contestId, required String recurringId}) =>
      "user/contest/get-details/$contestId/$recurringId";

  static String getStatusWiseContestDetailsGET(
          {required String contestId,
          required String recurringId,
          required String status}) =>
      "user/contest/get/$contestId/$recurringId/$status";

  /// game
  static String getGameDetailsGET({
    required String contestId,
    required String recurringId,
    required bool isJoined,
  }) =>
      isJoined
          ? isValEmpty(recurringId)
              ? "user/contest/start-reminder-details/$contestId"
              : "user/participate/maze/$contestId/$recurringId"
          : "user/contest/join-reminder-details/$contestId";

  static String getFreePracticeGameSizeGET = "admin/contest/list-practice";

  static String startGamePOST(
          {required String contestId, required String recurringId}) =>
      "user/participate/play-game/$contestId/$recurringId";

  static String finishGamePOST(
          {required String contestId, required String recurringId}) =>
      "user/participate/play-game/$contestId/$recurringId";

  /// status wise contest
  static String getMyUpcomingContestsPOST = "user/contest/list/upcoming";
  static String getMyLiveContestsPOST = "user/contest/list/live";
  static String getMyCompletedContestsPOST = "user/contest/list/completed";

  /// update profile
  static String updateProfileUrl = "user/update";
  static String getUserDetailsUrl = "user/get";
  static String uploadImageUrl = "user/profileImage";

  /// wallet
  static String walletUrl = "user/wallet";

  /// TDS
  static String getTdsCalculationByAmountPOST = "user/payment/tds";

  /// Payment Gateway
  static String paymentIdInitiateOfBusttoPG = "user/payment/order-initiate";

  /// bank details
  static String addBankDetailUrl = "user/payment/bank-detail-save";
  static String withdrawURL = "user/payment/payout";
  static String createOrderURL = "user/payment/intent";
  static String getBankDetailUrl = "user/payment/bank-detail-get";

  /// pancard details
  static String getPanCardDetailUrl = "user/payment/pancard";
  static String addPanCardDetailUrl = "user/payment/pan-verification";

  /// my transactions
  static String contestTransactionURL =
      "user/payment/transaction-history/contest";
  static String withdrawTransactionURL =
      "user/payment/transaction-history/withdraw";
  static String tdsTransactionURL = "user/payment/transaction-history/tds";
  static String depositTransactionURL =
      "user/payment/transaction-history/deposit";

  /// winners
  static String winnersURL = "user/participate/winner-list";

  ///
  static String comparisonUrl({required String userId}) =>
      "user/comparison/$userId";

  ///
  static String getJoinContestPricingDetails(
          {required String contestId, required String recurringId}) =>
      "user/participate/join-details/$contestId/$recurringId";

  static String getJoinContestPricingDetailsGET(
          {required String contestId, required String recurringId}) =>
      "user/participate/join-details/$contestId/$recurringId";

  static String joinContestPOST(
          {required String contestId, required String recurringId}) =>
      "user/participate/join/$contestId/$recurringId";

  /// winning board
  static String getMaxFillWinnerBoardPOST = "winner-board/max-sports";
  static String getCurrentFillWinnerBoardPOST = "winner-board/current-sports";

  /// leader board
  static String getLeaderBoardPOST(
          {required String contestId, required String recurringId}) =>
      "user/participate/list/$contestId/$recurringId";
}
