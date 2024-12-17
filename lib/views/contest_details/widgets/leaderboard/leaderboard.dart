import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/packages/cached_network_image/cached_network_image.dart';
import 'package:maze_king/views/contest_details/components/points_calculation_details_dialog.dart';
import 'package:maze_king/views/contest_details/widgets/leaderboard/leaderboard_controller.dart';
import 'package:maze_king/views/winners/winners_screen_controller.dart';

import '../../../../exports.dart';
import '../../../../res/empty_element.dart';
import '../../../../res/widgets/pull_to_refresh_indicator.dart';
import '../../../../utils/enums/contest_enums.dart';
import '../../contest_details_controller.dart';

class Leaderboard extends StatelessWidget {
  Leaderboard({
    super.key,
  });

  final ContestDetailsController mainCon = Get.find<ContestDetailsController>();
  final LeaderboardController con = Get.put(LeaderboardController());
  final WinnersScreenController con2 = Get.put(WinnersScreenController());

  get showThreeColumns =>
      (mainCon.contestDetailsType.value == ContestDetailsType.completed &&
          mainCon.contestDetailsModel.value.contestStatus != null &&
          mainCon.contestDetailsModel.value.contestStatus !=
              ContestStatus.inReview.name &&
          mainCon.contestDetailsModel.value.isRefunded != true);

  String _getImageUrl(String username) {
    try {
      // Find the user in the allWinners list
      final user = con2.allWinners.firstWhere(
        (winner) => winner.userName == username,
        // Return null if no match is found
      );
      return user.image ??
          "https://gotilo-maze-king.s3.ap-south-1.amazonaws.com/1731656714446_user_image.png";
    } catch (e) {
      // Handle any unexpected errors
      return "https://gotilo-maze-king.s3.ap-south-1.amazonaws.com/1731656714446_user_image.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      con.leaderboardList.sort((a, b) =>
          (a.rank == null ? double.infinity : a.rank!)
              .compareTo(b.rank == null ? double.infinity : b.rank!));

      return Column(
        children: [
        
          if (con.isLoading.isFalse && con.leaderboardList.isNotEmpty)
            Container(
              color: Theme.of(context).cardColor.withOpacity(0.8),
              child: Table(
                // border: TableBorder.all(color: Colors.black),
                columnWidths: (showThreeColumns)
                    ? {
                        0: const FlexColumnWidth(2.8),
                        1: const FlexColumnWidth(0.75),
                        2: const FlexColumnWidth(1.5),
                      }
                    : {
                        0: const FlexColumnWidth(1),
                      },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      tableTitle(context, "All Contestants",
                          paddingLeft: defaultPadding),
                      if (showThreeColumns) ...[
                        tableTitle(context, "Points", textAlign: TextAlign.end),
                        tableTitle(context, "Rank",
                            textAlign: TextAlign.end,
                            paddingRight: defaultPadding),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: con.isLoading.isFalse
                ? PullToRefreshIndicator(
                    onRefresh: () =>
                        mainCon.getContestDetailsAPI(isPullToRefresh: true),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      controller: con.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        con.leaderboardList.isNotEmpty
                            ? ListView.separated(
                                itemCount: con.leaderboardList.length,
                                padding: const EdgeInsets.only(
                                    bottom: defaultPadding),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  // if (kDebugMode) {
                                  //   print(con.leaderboardList[index].image);
                                  // } // print image url
                                  return Container(
                                    color: con.leaderboardList[index].userId ==
                                            LocalStorage.userId.value
                                        ? Theme.of(context).cardColor
                                        : Colors.transparent,
                                    child: Table(
                                        // border: TableBorder.all(color: Colors.black),
                                        columnWidths: (showThreeColumns)
                                            ? {
                                                0: const FlexColumnWidth(2.5),
                                                1: const FlexColumnWidth(1.05),
                                                2: const FlexColumnWidth(1.2),
                                              }
                                            : {
                                                0: const FlexColumnWidth(1),
                                              },
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: (index == 0 &&
                                                      con.leaderboardList[index]
                                                              .userId ==
                                                          con.myLeaderboardData
                                                              .value?.userId)
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                      .withOpacity(0.08)
                                                  : Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(0.7),
                                            ),
                                            children: [
                                              TableCell(
                                                child: Container(
                                                  // color: Colors.red,
                                                  margin: const EdgeInsets.only(
                                                      top: defaultPadding / 4,
                                                      bottom:
                                                          defaultPadding / 4,
                                                      left: defaultPadding,
                                                      right:
                                                          defaultPadding / 2),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                defaultRadius /
                                                                    2),
                                                        child: AppNetworkImage(
                                                          imageUrl:
                                                              // con.leaderboardList[index].image ?? "No url ",
                                                              _getImageUrl(con
                                                                  .leaderboardList[
                                                                      index]
                                                                  .userName
                                                                  .toString()),
                                                          fit: BoxFit.cover,
                                                          height: 40.w,
                                                          width: 40.w,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              defaultPadding /
                                                                  2),
                                                      SizedBox(
                                                        width: Get.width * 0.3,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              (con.leaderboardList[index].userId ==
                                                                      LocalStorage
                                                                          .userId
                                                                          .value
                                                                  ? "You"
                                                                  : con.leaderboardList[index]
                                                                          .userName ??
                                                                      "-"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                      fontSize:
                                                                          12.sp,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                            ),
                                                            if (mainCon.contestDetailsType
                                                                            .value ==
                                                                        ContestDetailsType
                                                                            .completed &&
                                                                    con
                                                                        .leaderboardList[
                                                                            index]
                                                                        .isRefunded ||
                                                                con
                                                                        .leaderboardList[
                                                                            index]
                                                                        .gameErrorRefund !=
                                                                    null ||
                                                                (con.leaderboardList[index].winningStatus ==
                                                                        WinningStatus
                                                                            .won
                                                                            .name &&
                                                                    !isValZero(con
                                                                            .leaderboardList[index]
                                                                            .winningAmount ??
                                                                        0)))
                                                              Text(
                                                                (con
                                                                        .leaderboardList[
                                                                            index]
                                                                        .isRefunded
                                                                    ? 'Refunded ${AppStrings.rupeeSymbol}${mainCon.contestDetailsModel.value.entryFee}'
                                                                    : con.leaderboardList[index].gameErrorRefund !=
                                                                            null
                                                                        ? 'Refunded due to game play issue ${AppStrings.rupeeSymbol}${mainCon.contestDetailsModel.value.entryFee}'
                                                                        : '${con.leaderboardList[index].userId == LocalStorage.userId.value ? "You won " : "Won "}${AppStrings.rupeeSymbol}${con.leaderboardList[index].winningAmount}'),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: AppColors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              /// For completed contest
                                              if (showThreeColumns) ...[
                                                /// POINTS
                                                TableCell(
                                                  child: con
                                                              .leaderboardList[
                                                                  index]
                                                              .isRefunded ||
                                                          con
                                                                  .leaderboardList[
                                                                      index]
                                                                  .gameErrorRefund !=
                                                              null
                                                      ? Container()
                                                      : Column(
                                                          children: [
                                                            Container(
                                                              // color: Colors.green,
                                                              child:

                                                                  /// Missed Play
                                                                  ((con.leaderboardList[index].joinStatus == null || con.leaderboardList[index].joinStatus == JoinStatus.none.name) &&
                                                                          con.leaderboardList[index].userId ==
                                                                              LocalStorage.userId.value)
                                                                      ? Text(
                                                                          AppStrings
                                                                              .missedPlay,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                              color: Theme.of(context).colorScheme.error,
                                                                              fontSize: 12.sp,
                                                                              fontWeight: FontWeight.w500),
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            if (mainCon.contestDetailsModel.value.contestStatus != null &&
                                                                                mainCon.contestDetailsModel.value.contestStatus != ContestStatus.inReview.name) {
                                                                              /// Points calculation details dialog
                                                                              Get.dialog(
                                                                                PointsCalculationDetailsDialog(
                                                                                  isNotPlayed: (con.leaderboardList[index].joinStatus == null || con.leaderboardList[index].joinStatus == JoinStatus.none.name),
                                                                                  isLoser: (con.leaderboardList[index].winningPercentage ?? 0).isLowerThan(100),
                                                                                  takenTime: (con.leaderboardList[index].winningTime ?? 0),
                                                                                  gamePoints: !isValEmpty(con.leaderboardList[index].winningPercentage) && !isValEmpty(con.leaderboardList[index].totalPercentage) ? (con.leaderboardList[index].winningPercentage! / con.leaderboardList[index].totalPercentage!) * 100 : 0,
                                                                                  timePoints: !isValEmpty(con.leaderboardList[index].winningTime) ? (con.leaderboardList[index].winningTime! / 60000000) * 100 : 0,
                                                                                  totalPoints: con.leaderboardList[index].point,
                                                                                ),
                                                                                useSafeArea: true,
                                                                              );
                                                                            }
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment: (con.leaderboardList[index].joinStatus == null || con.leaderboardList[index].joinStatus == JoinStatus.none.name) && con.leaderboardList[index].userId == LocalStorage.userId.value
                                                                                ? MainAxisAlignment.center
                                                                                : MainAxisAlignment.end,
                                                                            children: [
                                                                              Flexible(
                                                                                child: Text(
                                                                                  con.leaderboardList[index].joinStatus == null ? "-" : "${con.leaderboardList[index].point ?? 0}",
                                                                                  textAlign: TextAlign.end,
                                                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.subTextColor(context)),
                                                                                ),
                                                                              ),
                                                                              if (mainCon.contestDetailsModel.value.contestStatus != null && mainCon.contestDetailsModel.value.contestStatus != ContestStatus.inReview.name)
                                                                                Container(
                                                                                  // color: Colors.red,
                                                                                  padding: const EdgeInsets.all(defaultPadding / 4),
                                                                                  child: Icon(
                                                                                    Icons.info_outline,
                                                                                    size: 15.w,
                                                                                    color: AppColors.subTextColor(context).withOpacity(0.3),
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                            ),
                                                            if (kDebugMode) ...[
                                                              Text(
                                                                "J: ${con.leaderboardList[index].joinStatus}",
                                                              ),
                                                              Text(
                                                                "W: ${con.leaderboardList[index].winningStatus}",
                                                              ),
                                                            ]
                                                          ],
                                                        ),
                                                ),

                                                /// RANK
                                                TableCell(
                                                  child: Container(
                                                    // color: Colors.red,
                                                    margin: const EdgeInsets
                                                        .only(
                                                        top: defaultPadding / 4,
                                                        bottom:
                                                            defaultPadding / 4,
                                                        left:
                                                            defaultPadding / 2,
                                                        right: defaultPadding),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: '#',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontSize: 12.sp,
                                                                color: AppColors
                                                                    .subTextColor(
                                                                        context)),
                                                        children: [
                                                          TextSpan(
                                                            text: isValZero(con
                                                                        .leaderboardList[
                                                                            index]
                                                                        .rank ??
                                                                    0)
                                                                ? ""
                                                                : "${con.leaderboardList[index].rank ?? 0}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                        ],
                                                      ),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        ]),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                              )
                            :

                            /// Empty data view
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding * 5),
                                child: const EmptyElement(
                                    title: "No one has participated!"),
                              )
                      ],
                    ),
                  )
                : Container(
                    // padding: const EdgeInsets.symmetric(vertical: defaultPadding * 5),
                    child: UiUtils.appCircularProgressIndicator(),
                  ),
          ),
        ],
      );
    });
  }

  Widget title(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.subTextColor(context), fontWeight: FontWeight.w500),
    );
  }

  Widget tableTitle(
    BuildContext context,
    String title, {
    TextAlign textAlign = TextAlign.start,
    double paddingLeft = 0,
    double paddingRight = 0,
  }) {
    return Container(
      // color: AppColors.green,
      padding: EdgeInsets.only(
          top: defaultPadding / 2,
          bottom: defaultPadding / 2,
          left: paddingLeft,
          right: paddingRight),
      child: Text(
        title,
        textAlign: textAlign,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: AppColors.subTextColor(context)),
      ),
    );
  }

  Widget tableValue(BuildContext context, String title,
      {TextAlign textAlign = TextAlign.start}) {
    return Text(
      title,
      textAlign: textAlign,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
