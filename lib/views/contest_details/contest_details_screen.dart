import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/gradient_leanear_progress_bar.dart';
import 'package:maze_king/res/widgets/scaffold_widget.dart';
import '../../repositories/contest/contest_repository.dart';
import '../../res/app_amount_formatter.dart';
import '../../res/widgets/app_bar.dart';
import '../../res/widgets/app_dialog.dart';
import '../../res/widgets/tab_bar.dart';
import '../../utils/enums/contest_enums.dart';
import 'contest_details_controller.dart';
import 'widgets/leaderboard/leaderboard.dart';
import 'widgets/winning_board/winnings_board.dart';

class ContestDetailsScreen extends StatelessWidget {
  ContestDetailsScreen({super.key});

  final ContestDetailsController con = Get.put(ContestDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        length: 2,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: AppScaffoldBgWidget(
            opacity: 0.3,
            bgColor: Colors.white.withOpacity(0.9),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  MyAppBar(
                    showBackIcon: true,
                    title: con.contestDetailsType.value == ContestDetailsType.completed
                        ? "Contest Details"
                        : con.contestDetailsType.value == ContestDetailsType.live
                            ? "Play Now"
                            : con.remainingTime.value,
                    subTitle: (con.contestDetailsType.value == ContestDetailsType.completed || con.contestDetailsType.value == ContestDetailsType.live) ? null : "Game Starts In",
                    myAppBarSize: MyAppBarSize.medium,
                    centerTitle: true,
                    backgroundColor: con.isLoading.value ? Colors.transparent : Theme.of(context).cardColor.withOpacity(0.7) /*: Colors.transparent*/,
                  ),
                  if (con.isLoading.isFalse) ...[
                    /// UPCOMING CONTEST JOINING AND DETAILS CARD
                    if (con.contestDetailsType.value == ContestDetailsType.unJoined) upcomingContestJoiningCard(context),

                    /// Price Pool Widget
                    if (con.contestDetailsType.value != ContestDetailsType.unJoined) pricePoolCardView(context),

                    /// TODO
                    /// PLAY GAME BUTTON
                    if (con.contestDetailsType.value == ContestDetailsType.live)
                      AppButton(
                        padding: const EdgeInsets.all(defaultPadding),
                        disableButton: con.contestDetailsModel.value.joinStatus == JoinStatus.exit.name,
                        onPressed: () {
                          con.navigateToCountDownScreen();
                        },
                        title: AppStrings.playNow,
                      ),

                    /// TODO
                    /// GO GAME BUTTON
                    if (con.contestDetailsType.value == ContestDetailsType.upcoming)
                      AppButton(
                        padding: const EdgeInsets.all(defaultPadding),
                        onPressed: () {
                          con.navigateToCountDownScreen();
                        },
                        title: AppStrings.go,
                      ),

                    /// In review status
                    if (con.contestDetailsType.value == ContestDetailsType.completed && (con.contestDetailsModel.value.contestStatus == ContestStatus.inReview.name || con.contestDetailsModel.value.isRefunded == true))
                      Container(
                        color: Theme.of(context).cardColor,
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding / 2),
                          color: (con.contestDetailsModel.value.contestStatus == ContestStatus.inReview.name ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.tertiary).withOpacity(0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                con.contestDetailsModel.value.contestStatus == ContestStatus.inReview.name ? AppStrings.inReview : AppStrings.canceled,
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: con.contestDetailsModel.value.contestStatus == ContestStatus.inReview.name ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              if (con.contestDetailsModel.value.isRefunded == true)
                                GestureDetector(
                                  onTap: () {
                                    AppDialogs.dashboardCommonDialog(
                                      context,
                                      dialogTitle: "Canceled Contest",
                                      descriptionChild: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding,
                                        ).copyWith(bottom: defaultPadding),
                                        child: Text(
                                          AppStrings.canceledContestReason,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                      showButton: false.obs,
                                    );
                                  },
                                  child: Container(
                                    // color: Colors.red,
                                    padding: const EdgeInsets.only(left: defaultPadding / 4),
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 13.w,
                                      color: AppColors.subTextColor(context).withOpacity(0.3),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),

                    /// tabBar
                    MyTabBar(
                      tabAlignment: TabAlignment.start,
                      backgroundColor: Colors.transparent,
                      tabs: [
                        Tab(
                          child: Text(AppStrings.winnings),
                        ),
                        Tab(
                          child: Text(AppStrings.leaderboard),
                        ),
                      ],
                    ),

                    Expanded(
                      child: TabBarView(
                        children: [
                          /// WINNINGS TAB
                          WinningsBoard(),

                          /// LEADERBOARD
                          Leaderboard(),
                        ],
                      ),
                    ),
                  ],
                  if (con.isLoading.value)
                    Expanded(
                      child: Column(
                        children: [
                          const Spacer(),
                          UiUtils.appCircularProgressIndicator(),
                          const Spacer(),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget upcomingContestJoiningCard(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(defaultPadding / 1.5),
      // height: 200,
      // width: Get.width,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(defaultRadius),
        color: Theme.of(context).cardColor.withOpacity(0.7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.5 - defaultPadding,
                // color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.pricePool,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.subTextColor(context),
                          ),
                    ),
                    // 2.5.verticalSpace,
                    Text(
                      "${AppStrings.rupeeSymbol}${AppAmountFormatter.defaultFormatter(con.contestDetailsModel.value.maxPricePool)}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 17.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Get.width * 0.5 - defaultPadding,
                // color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.entry,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.subTextColor(context),
                          ),
                    ),
                    // 2.5.verticalSpace,
                    Text(
                      "${AppStrings.rupeeSymbol}${AppAmountFormatter.defaultFormatter(con.contestDetailsModel.value.entryFee)}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 17.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          5.verticalSpace,
          GradientProgressIndicator(
            value: ((con.contestDetailsModel.value.totalSpots - con.contestDetailsModel.value.availableSpots) == 0 ? 0.0001 : (con.contestDetailsModel.value.totalSpots - con.contestDetailsModel.value.availableSpots) / (con.contestDetailsModel.value.totalSpots == 0 ? 1 : con.contestDetailsModel.value.totalSpots)),
          ),
          5.verticalSpace,
          Row(
            children: [
              Text(
                "${con.contestDetailsModel.value.availableSpots} ${AppStrings.spotsLeft}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11.sp,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const Spacer(),
              Text(
                "${con.contestDetailsModel.value.totalSpots} ${AppStrings.spots}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11.sp,
                      color: AppColors.subTextColor(context),
                    ),
              ),
            ],
          ),
          5.verticalSpace,

          /// TODO
          /// JOIN BUTTON
          AppButton(
            onPressed: () async {
              await ContestRepository.getJoinContestPricingDetailsAPI(
                context,
                loader: con.buttonLoader,
                contestId: con.contestDetailsModel.value.id ?? "",
                recurringId: con.contestDetailsModel.value.recurring ?? "",
                entryFee: con.contestDetailsModel.value.entryFee,
                isNavFromDescScreen: true,
              );
            },
            loader: con.buttonLoader.value,
            title: "JOIN ${AppStrings.rupeeSymbol}${con.contestDetailsModel.value.entryFee}",
          )
        ],
      ),
    );
  }

  Widget pricePoolCardView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: defaultPadding, bottom: defaultPadding / 1.5),
      color: Theme.of(context).cardColor.withOpacity(0.7),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tableTitle(context, AppStrings.pricePool),
              tableValue(context, AppStrings.rupeeSymbol + AppAmountFormatter.defaultFormatter(con.contestDetailsModel.value.maxPricePool)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              tableTitle(context, AppStrings.spots),
              tableValue(context, "${con.contestDetailsModel.value.totalSpots}"),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              tableTitle(context, AppStrings.entry),
              tableValue(context, AppStrings.rupeeSymbol + AppAmountFormatter.defaultFormatter(con.contestDetailsModel.value.entryFee)),
            ],
          ),
        ],
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
