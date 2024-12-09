import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/contest/completed_contest_model.dart';
import 'package:maze_king/views/my_matches/widgets/completed/my_completed_matches_controller.dart';
import 'package:maze_king/views/my_matches/widgets/live/my_live_matches_controller.dart';
import 'package:maze_king/views/my_matches/widgets/upcoming/my_upcoming_matches_controller.dart';
import '../../data/models/contest/contest_details_model.dart';
import '../../data/models/contest/join_contest_pricing_model.dart';
import '../../data/models/contest/live_contest_model.dart';
import '../../data/models/contest/my_upcoming_contest_model.dart';
import '../../data/models/contest/upcoming_contest_model.dart';
import '../../exports.dart';
import '../../res/widgets/overlay_loader.dart';
import '../../views/commmon/join_contest_bottom_sheet/join_contest_bottom_sheet.dart';
import '../../views/contest_details/contest_details_controller.dart';
import '../../views/home_screen/home_controller.dart';
import '../wallet/wallet_repository.dart';

class ContestRepository {
  /// ***********************************************************************************
  ///                              GET UPCOMING CONTESTS
  /// ***********************************************************************************

  static Future<RxList<UpcomingContestModel>?> getUpcomingContestsAPI({
    bool isInitial = true,
    bool isPullToRefresh = false,
    RxBool? loader,  
  }) async {
    if (isRegistered<HomeController>()) {
      final HomeController con = Get.find<HomeController>();

      try {
        loader?.value = true;

        if (isInitial) {
          if (!isPullToRefresh) {
            con.upcomingContests.clear();
          }
          con.page.value = 1;
          con.nextPageAvailable.value = true;
        }

        return await APIFunction.getApiCall(
          apiName: ApiUrls.getUpcomingContestsGET,
          params: {
            "page": con.page.value,
            "limit": con.itemLimit.value,
          },
        ).then(
          (response) async {
            if (response != null && response['success'] == true) {
              final GetUpcomingContestDataModel model = GetUpcomingContestDataModel.fromJson(response);

              /// practice contest
              final UpcomingContestModel dummyPracticeModel = UpcomingContestModel(
                maxPricePool: 0,
                availableSpots: 0,
                totalSpots: 0,
                id: "-1",
                entryFee: 0,
                recurring: "",
                endTime: DateTime.now().add(const Duration(hours: 500)),
                startTime: DateTime.now().add(const Duration(hours: 500)),
              );
              void addPracticeContest() {
                /// add practice contest
                if (con.upcomingContests.isNotEmpty) {
                  if (con.upcomingContests[0].id != "-1") {
                    con.upcomingContests.insert(0, dummyPracticeModel);
                  }
                } else {
                  con.upcomingContests.add(dummyPracticeModel);
                }
              }

              ///
              if (model.data != null) {
                if (isPullToRefresh) {
                  con.upcomingContests.value = model.data!.upcomingContests ?? [];
                  addPracticeContest();
                } else {
                  con.upcomingContests.addAll(model.data!.upcomingContests ?? []);
                  addPracticeContest();
                }
                con.page.value++;
                con.nextPageAvailable.value = (model.data!.page ?? 0) < (model.data!.totalPages ?? 0);
                loader?.value = false;
                return con.upcomingContests;
              }
            }
            loader?.value = false;
            return null;
          },
        );
      } catch (e) {
        loader?.value = false;
        printErrors(type: "getUpcomingContestsAPI", errText: e);
      }
    }
    return null;
  }

  /// ***********************************************************************************
  ///                              GET MY UPCOMING CONTESTS
  /// ***********************************************************************************

  static Future<RxList<MyUpcomingContestModel>?> getMyUpcomingContestsAPI({
    bool isInitial = true,
    bool isPullToRefresh = false,
    RxBool? loader,
  }) async {
    if (isRegistered<MyUpcomingMatchesController>()) {
      final MyUpcomingMatchesController con = Get.find<MyUpcomingMatchesController>();

      try {
        loader?.value = true;

        if (isInitial) {
          if (!isPullToRefresh) {
            con.myUpcomingContests.clear();
          }
          con.page.value = 1;
          con.nextPageAvailable.value = true;
        }

        return await APIFunction.postApiCall(
          apiName: ApiUrls.getMyUpcomingContestsPOST,
          params: {
            "page": con.page.value,
            "limit": con.itemLimit.value,
          },
        ).then(
          (response) async {
            // log(jsonEncode(response));
            if (response != null && response['success'] == true) {
              final GetMyUpcomingContestDataModel model = GetMyUpcomingContestDataModel.fromJson(response);
              if (model.data != null) {
                if (isPullToRefresh) {
                  con.myUpcomingContests.value = model.data!.myUpcomingContests ?? [];
                } else {
                  con.myUpcomingContests.addAll((model.data!.myUpcomingContests ?? []).where((e) {
                    return !con.myUpcomingContests.contains(e);
                  }).toList());
                  // con.myUpcomingContests.toSet().toList().addAll(model.data!.myUpcomingContests ?? []);
                }
                con.page.value++;
                con.nextPageAvailable.value = (model.data!.page ?? 0) < (model.data!.totalPages ?? 0);
                loader?.value = false;

                /// START TIMER
                con.initialiseRemainingTimer();

                return con.myUpcomingContests;
              }
            }
            loader?.value = false;
            return null;
          },
        );
      } catch (e) {
        loader?.value = false;
        printErrors(type: "getMyUpcomingContestsAPI", errText: e);
      }
    }
    return null;
  }

  /// ***********************************************************************************
  ///                              GET MY LIVE CONTESTS
  /// ***********************************************************************************

  static Future<RxList<LiveContestModel>?> getMyLiveContestsAPI({
    bool isInitial = true,
    bool isPullToRefresh = false,
    RxBool? loader,
  }) async {
    if (isRegistered<MyLiveMatchesController>()) {
      final MyLiveMatchesController con = Get.find<MyLiveMatchesController>();

      try {
        loader?.value = true;

        if (isInitial) {
          if (!isPullToRefresh) {
            con.myLiveContests.clear();
          }
          con.page.value = 1;
          con.nextPageAvailable.value = true;
        }

        return await APIFunction.postApiCall(
          apiName: ApiUrls.getMyLiveContestsPOST,
          params: {
            "page": con.page.value,
            "limit": con.itemLimit.value,
          },
        ).then(
          (response) async {
            if (response != null && response['success'] == true) {
              final GetLiveContestDataModel model = GetLiveContestDataModel.fromJson(response);
              if (model.data != null) {
                if (isPullToRefresh) {
                  con.myLiveContests.value = model.data!.liveContests ?? [];
                } else {
                  con.myLiveContests.addAll(model.data!.liveContests ?? []);
                }
                con.page.value++;
                con.nextPageAvailable.value = (model.data!.page ?? 0) < (model.data!.totalPages ?? 0);
                loader?.value = false;

                /// START TIMER
                con.initialiseRemainingTimer();

                return con.myLiveContests;
              }
            }
            loader?.value = false;
            return null;
          },
        );
      } catch (e) {
        loader?.value = false;
        printErrors(type: "getMyLiveContestsAPI", errText: e);
      }
    }
    return null;
  }

  /// ***********************************************************************************
  ///                              GET MY COMPLETED CONTESTS
  /// ***********************************************************************************

  static Future<RxList<CompletedContestModel>?> getMyCompletedContestsAPI({
    bool isInitial = true,
    bool isPullToRefresh = false,
    RxBool? loader,
  }) async {
    if (isRegistered<MyCompletedMatchesController>()) {
      final MyCompletedMatchesController con = Get.find<MyCompletedMatchesController>();

      try {
        loader?.value = true;

        if (isInitial) {
          if (!isPullToRefresh) {
            con.myCompletedContests.clear();
          }
          con.page.value = 1;
          con.nextPageAvailable.value = true;
        }

        return await APIFunction.postApiCall(
          apiName: ApiUrls.getMyCompletedContestsPOST,
          params: {
            "page": con.page.value,
            "limit": con.itemLimit.value,
          },
        ).then(
          (response) async {
            // log(jsonEncode(response));
            if (response != null && response['success'] == true) {
              final GetCompletedContestDataModel model = GetCompletedContestDataModel.fromJson(response);
              if (model.data != null) {
                if (isPullToRefresh) {
                  con.myCompletedContests.value = model.data!.completedContests ?? [];
                } else {
                  con.myCompletedContests.addAll(model.data!.completedContests ?? []);
                }
                con.page.value++;
                con.nextPageAvailable.value = (model.data!.page ?? 0) < (model.data!.totalPages ?? 0);
                loader?.value = false;

                return con.myCompletedContests;
              }
            }
            loader?.value = false;
            return null;
          },
        );
      } catch (e) {
        loader?.value = false;
        printErrors(type: "getMyCompletedContestsAPI", errText: e);
      }
    }
    return null;
  }

  /// ***********************************************************************************
  ///                            GET JOIN CONTEST PRICING DETAILS
  /// ***********************************************************************************

  static Future<JoinContestPricingModel?> getJoinContestPricingDetailsAPI(
    BuildContext context, {
    RxBool? loader,
    required String contestId,
    required String recurringId,
    required num entryFee,
    required bool isNavFromDescScreen,
  }) async {
    try {
      loader?.value = true;
      OverlayLoader.showLoader(context);
      return await APIFunction.getApiCall(
        apiName: ApiUrls.getJoinContestPricingDetailsGET(contestId: contestId, recurringId: recurringId),
        body: {
          "join_amount": entryFee,
        },
      ).then(
        (response) async {
          printOkStatus(LocalStorage.accessToken.value);
          if (response != null && response['success'] == true) {
            final GetJoinContestPricingDataModel model = GetJoinContestPricingDataModel.fromJson(response);
            loader?.value = false;
            OverlayLoader.hideLoader();
            if (model.joinContestPricingModel != null) {
              if (model.joinContestPricingModel!.insufficientBalance == false) {
                /// enough balance found
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return JoinContestBottomSheet(
                        contestId: contestId,
                        recurringId: recurringId,
                        entryFee: entryFee,
                        isNavFromDescScreen: isNavFromDescScreen,
                        joinContestPricingModel: model.joinContestPricingModel!,
                      );
                    });
              } else {
                /// insufficient balance found
                printOkStatus("insufficient balance found");
                Get.toNamed(
                  AppRoutes.addCashScreen,
                  arguments: {
                    'money': "${model.joinContestPricingModel!.requireAmount}",
                    "whenCompleteFunction": () async {
                      await ContestRepository.getJoinContestPricingDetailsAPI(
                        context,
                        // isLoader: isLoading,
                        contestId: contestId,
                        recurringId: recurringId,
                        entryFee: entryFee,
                        isNavFromDescScreen: isNavFromDescScreen,
                      );
                    }
                  },
                );
              }

              return model.joinContestPricingModel;
            }
          }
          OverlayLoader.hideLoader();
          loader?.value = false;

          return null;
        },
      );
    } catch (e) {
      loader?.value = false;
      OverlayLoader.hideLoader();

      printErrors(type: "getJoinContestPricingDetailsAPI", errText: e);
    }
    return null;
  }

  /// ***********************************************************************************
  ///                                       JOIN CONTEST
  /// ***********************************************************************************

  static Future<dynamic> joinContestAPI({
    RxBool? loader,
    required String contestId,
    required String recurringId,
    required num unUtilized,
    required num winning,
    required num discount,
    required bool isNavFromDescScreen,
  }) async {
    try {
      loader?.value = true;

      return await APIFunction.postApiCall(
        apiName: ApiUrls.joinContestPOST(contestId: contestId, recurringId: recurringId),
        body: {
          "un_utilized": unUtilized,
          "winning": winning,
          "discount": discount,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            loader?.value = false;
            UiUtils.toast(response['message'] ?? "");

            /// subscribe notification topic for this contest
            // NotificationService.subscribeTopic(contestId.trim());

            if (isNavFromDescScreen) {
              /// nav from contest desc screen
              Get.back();

              /// Contest details screen
              if (isRegistered<ContestDetailsController>()) {
                ContestDetailsController con = Get.find<ContestDetailsController>();
                con.updateContestTypeEnumByStringType("upcoming");
                await con.getContestDetailsAPI();
              }

              /// home screen
              if (isRegistered<HomeController>()) {
                HomeController con = Get.find<HomeController>();
                int index = con.upcomingContests.indexWhere((element) => element.id == contestId && element.recurring == recurringId);
                con.upcomingContests.removeAt(index);

                con.getContestsAPICall(isPullToRefresh: true);
              }

              WalletRepository.getWalletDetailsAPI();
            } else {
              /// nav from home screen
              Get.back();
              if (isRegistered<HomeController>()) {
                HomeController con = Get.find<HomeController>();
                int index = con.upcomingContests.indexWhere((element) => element.id == contestId && element.recurring == recurringId);
                con.upcomingContests.removeAt(index);

                con.getContestsAPICall(isPullToRefresh: true);
              }

              WalletRepository.getWalletDetailsAPI();
            }
            return response;
          }
          loader?.value = false;
          return null;
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "joinContestAPI", errText: e);
    }
    return null;
  }

  /// ***********************************************************************************
  ///                                  GET CONTEST DETAILS
  /// ***********************************************************************************

  static Future<ContestDetailsModel?> getContestDetailsAPI({
    RxBool? loader,
    String? contestStatus,
    required String contestId,
    required String recurringId,
  }) async {
    try {
      loader?.value = true;

      return await APIFunction.getApiCall(
        apiName: isValEmpty(contestStatus) ? ApiUrls.getContestDetailsGET(contestId: contestId, recurringId: recurringId) : ApiUrls.getStatusWiseContestDetailsGET(contestId: contestId, recurringId: recurringId, status: contestStatus!),
      ).then(
        (response) async {
          // log(jsonEncode(response));
          if (response != null && response['success'] == true) {
            final GetContestDetailsDataModel model = GetContestDetailsDataModel.fromJson(response);
            loader?.value = false;

            if (model.contestDetails != null) {
              if (isRegistered<ContestDetailsController>()) {
                final ContestDetailsController con = Get.find<ContestDetailsController>();
                con.contestDetailsModel.value = model.contestDetails!;
                con.updateContestTypeEnumByStringType(con.contestDetailsModel.value.participateStatus);
                // con.updateContestTypeEnumByStringType("live");
                /// If users have not participated in the contest and current time is after than the game start time,
                DateTime gameStartTime = con.contestDetailsModel.value.startTime;
                if (con.contestDetailsModel.value.participateStatus == null && DateTime.now().isAfter(gameStartTime.toLocal())) {
                  UiUtils.toast("Contest join time is over!");
                  Get.back();
                }
              }

              return model.contestDetails!;
            }
          }

          loader?.value = false;

          return null;
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "getContestDetailsAPI", errText: e);
    }
    return null;
  }
}
