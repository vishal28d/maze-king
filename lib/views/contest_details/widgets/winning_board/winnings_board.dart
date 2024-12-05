import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/res/empty_element.dart';
import 'package:maze_king/views/contest_details/contest_details_controller.dart';
import 'package:maze_king/views/contest_details/widgets/winning_board/winning_board_controller.dart';
import '../../../../exports.dart';
import '../../../../res/app_amount_formatter.dart';
import '../../../../res/widgets/pull_to_refresh_indicator.dart';

class WinningsBoard extends StatelessWidget {
  WinningsBoard({super.key});

  final WiningBoardController con = Get.put(WiningBoardController());
  final ContestDetailsController mainCon = Get.find<ContestDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // printOkStatus("C:${con.currentFillRankingList.length} M:${con.maxFillRankingList.length} ${con.selectedIndex.value}");
      return PullToRefreshIndicator(
        onRefresh: () => mainCon.getContestDetailsAPI(isPullToRefresh: true),
        child: ListView(
          padding: const EdgeInsets.symmetric(),
          children: [
            /// Tab Bar
            if (mainCon.contestDetailsType.value != ContestDetailsType.completed && (mainCon.contestDetailsModel.value.totalSpots - mainCon.contestDetailsModel.value.availableSpots) > 3)
              Container(
                color: Theme.of(context).cardColor.withOpacity(0.7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          con.tabList.length,
                          (index) => tabView(
                            context,
                            title: con.tabList[index],
                            isSelected: con.selectedIndex.value == index,
                            onTap: () {
                              if (index != con.selectedIndex.value) {
                                con.selectedIndex.value = index;
                                //max
                                if (index == 0 && con.maxFillRankingList.isEmpty) {
                                  con.getMaxFillWinnerBoardAPI();
                                }
                                //current

                                else if (index == 1) {
                                  con.getCurrentFillWinnerBoardAPI();
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            /// Rank and wining title row
            Container(
              color: Theme.of(context).cardColor.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Row(
                children: [
                  title(context, "Rank"),
                  const Spacer(),
                  title(context, "Winnings"),
                ],
              ),
            ),

            con.isLoading.isFalse
                ? con.rankingList.isNotEmpty
                    ?

                    /// Ranks and winnings list
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: con.rankingList.length,
                        physics: const RangeMaintainingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding,
                                ),
                                color: Theme.of(context).cardColor.withOpacity(0.4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*index < 3
                            ? SvgPicture.asset(
                                index == 0
                                    ? AppAssets.rankOneSVG
                                    : index == 1
                                        ? AppAssets.rankTwoSVG
                                        : AppAssets.rankThreeSVG,
                                height: defaultPadding * 1.9,
                              )
                            :*/
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 3, vertical: defaultPadding / 1.5).copyWith(right: 0),
                                      child: Text(
                                        "#",
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.unselectedIcon(context),
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2, vertical: defaultPadding / 1.5).copyWith(left: 0),
                                      child: Text(
                                        con.rankingList[index].entries.first.key,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.unselectedIcon(context),
                                            ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.only(left: defaultPadding / 2, top: defaultPadding / 1.5, bottom: defaultPadding / 1.5),
                                      child: Text(
                                        "${AppStrings.rupeeSymbol}${AppAmountFormatter.defaultFormatter(con.rankingList[index].entries.first.value)}",
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: AppColors.unselectedIcon(context)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider()
                            ],
                          );
                        })
                    :

                    /// Empty data view
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: defaultPadding * 5, horizontal: defaultPadding),
                        child: Column(
                          children: [
                            const EmptyElement(
                              title: "Winner board not listed!",
                              padding: EdgeInsets.zero,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 15.w,
                                ),
                                5.horizontalSpace,
                                const Flexible(child: Text("At least 4 filled spots required to get the winnings")),
                              ],
                            ),
                          ],
                        ),
                      )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding * 5),
                    child: UiUtils.appCircularProgressIndicator(),
                  ),

            defaultPadding.verticalSpace
          ],
        ),
      );
    });
  }

  Widget tabView(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width / 3,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 6),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget title(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.subTextColor(context), fontWeight: FontWeight.w500),
    );
  }

  Widget tableTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.subTextColor(context)),
    );
  }

  Widget tableValue(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
