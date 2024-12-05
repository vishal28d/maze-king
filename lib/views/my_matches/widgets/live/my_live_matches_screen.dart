import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/utils/enums/contest_enums.dart';

import '../../../../exports.dart';
import '../../../../res/empty_element.dart';
import '../../../../res/widgets/contest_widgets.dart';
import '../../../../res/widgets/pull_to_refresh_indicator.dart';
import '../../../contest_details/contest_details_controller.dart';
import 'my_live_matches_controller.dart';

class MyLiveMatches extends StatelessWidget {
  MyLiveMatches({super.key});

  final MyLiveMatchesController con = Get.put(MyLiveMatchesController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PullToRefreshIndicator(
        onRefresh: () {
          return con.getContestsAPICall(isPullToRefresh: true);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: con.isLoading.isFalse
              ? ListView(
                  padding: EdgeInsets.zero,
                  controller: con.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    con.myLiveContests.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: con.myLiveContests.length,
                            padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return Column(
                                  children: [
                                    /// Tab change loader
                                    if (con.tabChangeLoader.value && index == 0) UiUtils.appCircularProgressIndicator(padding: const EdgeInsets.only(top: defaultPadding, bottom: defaultPadding * 2)),

                                    /// Contest
                                    AppContestWidgets.liveContest(
                                      context,
                                      pricePoolName: AppStrings.pricePool,
                                      pricePool: con.myLiveContests[index].maxPricePool,
                                      entryFee: con.myLiveContests[index].entryFee,
                                      startTime: con.myLiveContests[index].startTime,
                                      remainingTime: index <= con.contestRemainingTimeList.length - 1 ? con.contestRemainingTimeList[index] : "wait",
                                      // totalSpots: (con.myLiveContests[index].totalSpots - con.myLiveContests[index].availableSpots),
                                      filledSpots: con.myLiveContests[index].totalSpots - con.myLiveContests[index].availableSpots,
                                      remainingSpots: con.myLiveContests[index].availableSpots,
                                      isDisableButton: con.myLiveContests[index].joinStatus == JoinStatus.exit.name,
                                      onButtonTap: () {
                                        try {
                                          Get.toNamed(
                                            AppRoutes.gameCountdownScreen,
                                            arguments: {
                                              "contestId": con.myLiveContests[index].contestId.toString(),
                                              "recurringId": con.myLiveContests[index].recurring.toString(),
                                              "whenCompleteFunction": () async {
                                                printOkStatus("FROM LIVE CONTEST --------------");

                                                // await con.getContestsAPICall(isPullToRefresh: true, isLoader: con.isLoading);
                                                /*.then((value) => Future.delayed(
                                                    const Duration(seconds: 1),
                                                    () => con.getContestsAPICall(isPullToRefresh: true),
                                                  ))*/
                                              }
                                            },
                                          );

                                          /// DISABLE PLAY BUTTON
                                          con.myLiveContests[index].joinStatus = JoinStatus.exit.name;
                                        } catch (e) {}
                                      },
                                      onTapOfContest: () {
                                        Get.toNamed(
                                          AppRoutes.contestDetailsScreen,
                                          arguments: {
                                            "contestDetailsType": ContestDetailsType.live,
                                            "contestId": con.myLiveContests[index].contestId.toString(),
                                            "recurringId": con.myLiveContests[index].recurring.toString(),
                                          },
                                        );
                                      },
                                    ),

                                    /// Pagination Loader
                                    if (con.paginationLoading.value && con.myLiveContests.length == index + 1) UiUtils.appCircularProgressIndicator(),
                                  ],
                                );
                              });
                            },
                          )
                        : EmptyElement(
                            padding: EdgeInsets.symmetric(vertical: Get.height / 3.5),
                            title: "Contests Not Found",
                            // svgPath: AppAssets.appBarLogoSVG,
                          )
                  ],
                )
              : UiUtils.appCircularProgressIndicator(),
        ),
      );
    });
  }
}
