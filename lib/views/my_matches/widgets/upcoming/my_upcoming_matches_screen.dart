import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/res/widgets/pull_to_refresh_indicator.dart';

import '../../../../exports.dart';
import '../../../../res/empty_element.dart';
import '../../../../res/widgets/contest_widgets.dart';
import '../../../contest_details/contest_details_controller.dart';
import 'my_upcoming_matches_controller.dart';

class MyUpcomingMatchesScreen extends StatelessWidget {
  MyUpcomingMatchesScreen({super.key});

  final MyUpcomingMatchesController con = Get.put(MyUpcomingMatchesController());

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
                  controller: con.scrollController,
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    con.myUpcomingContests.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: con.myUpcomingContests.length,
                            padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return Column(
                                  children: [
                                    /// Tab change loader
                                    if (con.tabChangeLoader.value && index == 0) UiUtils.appCircularProgressIndicator(padding: const EdgeInsets.only(top: defaultPadding, bottom: defaultPadding * 2)),

                                    /// Contest
                                    AppContestWidgets.upcomingContest(
                                      context,
                                      isMyMatchContest: true,
                                      pricePoolName: AppStrings.pricePool,
                                      pricePool: con.myUpcomingContests[index].maxPricePool,
                                      entryFee: con.myUpcomingContests[index].entryFee,
                                      // brainImage:con.myUpcomingContests[index].
                                      startTime: con.myUpcomingContests[index].startTime,
                                      brainImage: con.myUpcomingContests[index].brainImage,
                                      contestTitle: con.myUpcomingContests[index].contest_title,
                                      contestImage: con.myUpcomingContests[index].contest_image,
                                      remainingTime: index <= con.contestRemainingTimeList.length - 1 ? con.contestRemainingTimeList[index] : "wait",
                                      totalSpots: con.myUpcomingContests[index].totalSpots,
                                      filledSpots: con.myUpcomingContests[index].totalSpots - con.myUpcomingContests[index].availableSpots,
                                      remainingSpots: con.myUpcomingContests[index].availableSpots,
                                      onButtonTap: () {
                                        Get.toNamed(
                                          AppRoutes.gameCountdownScreen,
                                          arguments: {
                                            "contestId": con.myUpcomingContests[index].contestId.toString(),
                                            "recurringId": con.myUpcomingContests[index].recurring.toString(),
                                            "whenCompleteFunction": () async {
                                              // await con.getContestsAPICall(isPullToRefresh: true, isLoader: con.isLoading);
                                            }
                                          },
                                        )?.whenComplete(() {
                                          // con.onInit();
                                        });
                                      },
                                      onTapOfContest: () {
                                        Get.toNamed(
                                          AppRoutes.contestDetailsScreen,
                                          arguments: {
                                            "contestDetailsType": ContestDetailsType.upcoming,
                                            "contestId": con.myUpcomingContests[index].contestId.toString(),
                                            "recurringId": con.myUpcomingContests[index].recurring.toString(),
                                          },
                                        )?.whenComplete(() {
                                          // con.onInit();
                                        });
                                      },
                                    ),

                                    /// Pagination Loader
                                    if (con.paginationLoading.value && con.myUpcomingContests.length == index + 1) UiUtils.appCircularProgressIndicator(),
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
