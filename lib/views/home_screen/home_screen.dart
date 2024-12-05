import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/empty_element.dart';
import 'package:maze_king/res/widgets/app_bar.dart';
import 'package:maze_king/res/widgets/app_dialog.dart';
import 'package:maze_king/res/widgets/contest_widgets.dart';

import '../../repositories/contest/contest_repository.dart';
import '../../res/widgets/pull_to_refresh_indicator.dart';
import '../../res/widgets/scaffold_widget.dart';
import '../contest_details/contest_details_controller.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeCon = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Sort the upcoming contests list by pin_to_top
      final sortedContests = homeCon.upcomingContests
          .where((contest) => contest.pin_to_top != null) // Filter out contests where pin_to_top is null
          .toList()
        ..sort((a, b) {
          // Check if both contests are pinned to the top
          if (a.pin_to_top == true && b.pin_to_top == true) {
            // If both are pinned, sort by top_position
            // return a.top_position!.compareTo(b.top_position as num);
            return (a.top_position ?? 0).compareTo(b.top_position ?? 0);
          } else if (a.pin_to_top == true) {
            // If only 'a' is pinned, it should come first
            return -1; // 'a' should be before 'b'
          } else if (b.pin_to_top == true) {
            // If only 'b' is pinned, it should come first
            return 1; // 'b' should be after 'a'
          } else {
            // If neither is pinned, maintain original order (or use another criteria if needed)
            return 0;
          }
        });

      return AppScaffoldBgWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              /// AppBar
              MyAppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(
                    bottom: defaultPadding,
                    left: defaultPadding * 1.25,
                    right: defaultPadding,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.appBarLogoSVG,
                    height: 34.h,
                    alignment: Alignment.topCenter,
                  ),
                ),
                backgroundColor: Colors.transparent,
                actions: [
                  customTextButton(
                    context,
                    title: "NEW USER GUIDE",
                    assetVideoPath: LocalStorage.userGuideVideoLink.value,
                    loader: homeCon.userGuideLoader,
                    disable: homeCon.howToPlayLoader.value ||
                        homeCon.userGuideLoader.value,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding / 6,
                      horizontal: defaultPadding / 2,
                    ),
                    suffixSvg: AppAssets.playSVG,
                  ),
                  appBarActionButton(
                    svgIconPath: AppAssets.walletGraphicSVG,
                    onTap: () {
                      Get.toNamed(AppRoutes.walletScreen);
                    },
                  ),
                ],
                bottomWidget: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customTextButton(
                        context,
                        title: "HOW TO PLAY",
                        assetVideoPath: LocalStorage.howToPlayVideoLink.value,
                        loader: homeCon.howToPlayLoader,
                        disable: homeCon.howToPlayLoader.value ||
                            homeCon.userGuideLoader.value,
                      ),
                    ],
                  ),
                ),
              ),

              /// Contests
              Expanded(
                child: PullToRefreshIndicator(
                  onRefresh: () {
                    return homeCon.getContestsAPICall(isPullToRefresh: true);
                  },
                  child: homeCon.isLoading.isFalse
                      ? ListView(
                    padding: EdgeInsets.zero,
                    controller: homeCon.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      homeCon.upcomingContests.isNotEmpty
                          ? ListView.builder(
                        physics:
                        const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: homeCon.upcomingContests.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding,
                        ).copyWith(top: 0),
                        itemBuilder: (context, index) {
                          return Obx(() {
                            return Column(
                              children: [
                                /// Contest
                                index == 0
                                    ? AppContestWidgets
                                    .freePracticeContest(
                                  context,
                                  onButtonTap: () async {
                                    deleteGameViewController();
                                    Get.toNamed(
                                      AppRoutes.gameViewScreen,
                                      arguments: {
                                        "isFreePracticeMode":
                                        true,
                                      },
                                    )?.whenComplete(() =>
                                        homeCon.getContestsAPICall(
                                            isPullToRefresh:
                                            true));
                                  },
                                  onTapOfContest: () {},
                                )
                                    : AppContestWidgets
                                    .upcomingContest(
                                  context,
                                  isMyMatchContest: false,
                                  pricePoolName:
                                  AppStrings.pricePool,
                                  pricePool: sortedContests[
                                  index-1]
                                      .maxPricePool,
                                  brainImage: sortedContests[index-1].brainImage,
                                  entryFee: sortedContests[
                                  index-1]
                                      .entryFee,
                                  startTime: sortedContests[
                                  index-1]
                                      .startTime,
                                  contestTitle: sortedContests[
                                  index-1]
                                      .contest_title,
                                  contestImage: sortedContests[
                                  index-1]
                                      .contest_image,
                                  remainingTime: index <= homeCon.timerList.length
                                      ? homeCon.timerList[index]
                                      : "Wait",
                                  totalSpots: sortedContests[
                                  index-1]
                                      .totalSpots,
                                  filledSpots: sortedContests[
                                  index-1]
                                      .totalSpots -
                                      sortedContests[index-1]
                                          .availableSpots,
                                  isPinned: sortedContests[index-1].pin_to_top,
                                  remainingSpots:
                                  sortedContests[index-1]
                                      .availableSpots,
                                  onButtonTap: () async {
                                    if (homeCon.debounceTimer
                                        ?.isActive ??
                                        false) {
                                      homeCon.debounceTimer
                                          ?.cancel();
                                    }
                                    homeCon.debounceTimer =
                                        Timer(
                                          homeCon.debounceDuration,
                                              () async {
                                            await ContestRepository
                                                .getJoinContestPricingDetailsAPI(
                                              context,
                                              contestId:
                                              sortedContests[
                                              index-1]
                                                  .id
                                                  .toString(),
                                              recurringId:
                                              sortedContests[
                                              index-1]
                                                  .recurring
                                                  .toString(),
                                              entryFee:
                                              sortedContests[
                                              index-1]
                                                  .entryFee,
                                              isNavFromDescScreen:
                                              false,
                                            );
                                          },
                                        );
                                  },
                                  onTapOfContest: () {
                                    Get.toNamed(
                                      AppRoutes
                                          .contestDetailsScreen,
                                      arguments: {
                                        "contestDetailsType":
                                        ContestDetailsType
                                            .unJoined,
                                        "contestId":
                                        sortedContests[
                                        index-1]
                                            .id
                                            .toString(),
                                        "recurringId":
                                        sortedContests[
                                        index-1]
                                            .recurring
                                            .toString(),
                                      },
                                    );
                                  },
                                ),

                                /// Pagination Loader
                                if (homeCon.paginationLoading.value &&
                                    sortedContests.length ==
                                        index + 1)
                                  UiUtils
                                      .appCircularProgressIndicator(),
                              ],
                            );
                          });
                        },
                      )
                          : EmptyElement(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height / 3.5),
                        title: "Contests Not Found",
                      ),
                    ],
                  )
                      : UiUtils.appCircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }



  Widget customTextButton(
    BuildContext context, {
    required String title,
    required String assetVideoPath,
    required RxBool loader,
    required bool disable,
    Color? bgColor,
    double? fontSize,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    String? suffixSvg,
    /*required Function() onTap,*/
  }) {
    return GestureDetector(
      onTap: !disable
          ? () async {
              if (homeCon.debounceTimer?.isActive ?? false) {
                homeCon.debounceTimer?.cancel();
              }
              homeCon.debounceTimer = Timer(
                homeCon.debounceDurationOfInstructions,
                () async {
                  /// ACTION
                  AppDialogs.videoInstructionDialogueFunction(
                      title: title,
                      assetVideoPath: assetVideoPath,
                      loader: loader);
                },
              );
            }
          : null,
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 3),
        decoration: BoxDecoration(
            gradient: bgColor == null ? appButtonLinearGradient : null,
            color: bgColor,
            borderRadius: BorderRadius.circular(defaultRadius * 10)),
        child: loader.isFalse
            ? Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.getColorOnBackground(
                                  Theme.of(context).primaryColor)
                              .withOpacity(1),
                          fontSize: fontSize,
                        ),
                  ),
                  if (!isValEmpty(suffixSvg))
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding / 5),
                      child: SvgPicture.asset(
                        suffixSvg!,
                        colorFilter: AppColors.iconColorFilter(context,
                            color: Colors.white),
                        width: 11.sp,
                      ),
                    )
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 10.sp,
                  height: 10.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.getColorOnBackground(
                        Theme.of(context).primaryColor),
                  ),
                ),
              ),
      ),
    );
  }

  Widget customInstructionButton(
    BuildContext context, {
    required String title,
    required String assetVideoPath,
    required RxBool loader,
    required bool disable,
    /*required Function() onTap,*/
  }) {
    return Container(
      margin: const EdgeInsets.only(
          right: defaultPadding,
          top: defaultPadding / 4,
          bottom: defaultPadding / 4),
      child: TextButton(
        onPressed: loader.isFalse && !disable
            ? () async {
                AppDialogs.videoInstructionDialogueFunction(
                    title: title,
                    assetVideoPath: assetVideoPath,
                    loader: loader);
              }
            : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            Theme.of(context).primaryColor.withOpacity(0.05),
          ),
        ),
        child: loader.isFalse
            ? Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            : SizedBox(
                width: 20.sp,
                height: 20.sp,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                )),
      ),
    );
  }
}
