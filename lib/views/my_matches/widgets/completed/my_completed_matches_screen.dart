import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../exports.dart';
import '../../../../res/empty_element.dart';
import '../../../../res/widgets/contest_widgets.dart';
import '../../../../res/widgets/pull_to_refresh_indicator.dart';
import '../../../../utils/enums/contest_enums.dart';
import '../../../contest_details/contest_details_controller.dart';
import 'my_completed_matches_controller.dart';

class MyCompletedMatches extends StatelessWidget {
  MyCompletedMatches({super.key});

  final MyCompletedMatchesController con = Get.put(MyCompletedMatchesController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // con.myCompletedContests.forEach((e) {
      //   printOkStatus(e.id);
      // });

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
                    con.myCompletedContests.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: con.myCompletedContests.length,
                            padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return Column(
                                  children: [
                                    /// Tab change loader
                                    if (con.tabChangeLoader.value && index == 0) UiUtils.appCircularProgressIndicator(padding: const EdgeInsets.only(top: defaultPadding, bottom: defaultPadding * 2)),

                                    /// Contest
                                    AppContestWidgets.completedContest(
                                      context,
                                      pricePoolName: AppStrings.pricePool /*con.myCompletedContests[index].winningStatus*/,
                                      pricePool: con.myCompletedContests[index].maxPricePool,
                                      entryFee: con.myCompletedContests[index].entryFee,
                                      startTime: con.myCompletedContests[index].startTime,
                                      totalSpots: (con.myCompletedContests[index].totalSpots - con.myCompletedContests[index].availableSpots),
                                      points: con.myCompletedContests[index].point.toDouble(),
                                      rank: con.myCompletedContests[index].rank,
                                      isWon: con.myCompletedContests[index].winningStatus == WinningStatus.won.name && !isValZero(con.myCompletedContests[index].winningAmount ?? 0),
                                      isRefunded: con.myCompletedContests[index].isRefunded,
                                      gameErrorRefund: con.myCompletedContests[index].gameErrorRefund,
                                      isUnderReview: con.myCompletedContests[index].contestStatus == ContestStatus.inReview.name,
                                      isNotPlayed: isValEmpty(con.myCompletedContests[index].joinStatus) || con.myCompletedContests[index].joinStatus == JoinStatus.none.name,
                                      winningAmount: con.myCompletedContests[index].winningAmount ?? 0,
                                      onTapOfContest: () {
                                        // Refunded due to game play issue
                                        Get.toNamed(
                                          AppRoutes.contestDetailsScreen,
                                          arguments: {
                                            "contestDetailsType": ContestDetailsType.completed,
                                            "contestId": con.myCompletedContests[index].contestId.toString(),
                                            "recurringId": con.myCompletedContests[index].recurring.toString(),
                                          },
                                        );
                                      },
                                    ),

                                    /// Pagination Loader
                                    if (con.paginationLoading.value && con.myCompletedContests.length == index + 1) UiUtils.appCircularProgressIndicator(),
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
