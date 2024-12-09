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
      // Calculate the count of non-pinned contests
      int nonPinnedContestsCount = homeCon.upcomingContests
          .where((contest) => contest.pin_to_top == false)
          .length;

      // Sort contests to place pinned contests at the top
      final sortedContests = homeCon.upcomingContests
          .where((contest) => contest.pin_to_top != null)
          .toList()
        ..sort((a, b) {
          if (a.pin_to_top == true && b.pin_to_top == true) {
            return (a.top_position ?? 0).compareTo(b.top_position ?? 0);
          } else if (a.pin_to_top == true) {
            return -1; // Pin to top moves to the top
          } else if (b.pin_to_top == true) {
            return 1; // Pin to top moves to the top
          } else {
            return 0; // No change in order for non-pinned contests
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

              /// Contests Section
              Expanded(
                child: PullToRefreshIndicator(
                  onRefresh: () => homeCon.getContestsAPICall(isPullToRefresh: true),
                  child: homeCon.isLoading.isFalse
                      ? ListView(
                          padding: EdgeInsets.zero,
                          controller: homeCon.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            /// Contest List
                            sortedContests.isNotEmpty
                                ? ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: sortedContests.length + 1,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: defaultPadding,
                                    ).copyWith(top: 0),
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return AppContestWidgets.freePracticeContest(
                                          context,
                                          onButtonTap: () async {
                                            deleteGameViewController();
                                            Get.toNamed(
                                              AppRoutes.gameViewScreen,
                                              arguments: {
                                                "isFreePracticeMode": true,
                                              },
                                            )?.whenComplete(() =>
                                                homeCon.getContestsAPICall(
                                                  isPullToRefresh: true,
                                                ));
                                          },
                                          onTapOfContest: () {},
                                        );
                                      } else {
                                        final contest = sortedContests[(index - 1)];

                                        // Show only free contest for "JohnSmith"
                                        if (LocalStorage.userName == "JohnSmith" &&
                                            index > 1) {
                                          return const SizedBox.shrink();
                                        }

                                        return AppContestWidgets.upcomingContest(
                                          context,
                                          isMyMatchContest: false,
                                          pricePoolName: AppStrings.pricePool,
                                          pricePool: contest.maxPricePool,
                                          brainImage: contest.brainImage,
                                          entryFee: contest.entryFee,
                                          startTime: contest.startTime,
                                          contestTitle: contest.contest_title,
                                          contestImage: contest.contest_image,
                                          remainingTime: index <=
                                                  homeCon.timerList.length
                                              ? homeCon.timerList[(index + nonPinnedContestsCount)% sortedContests.length]
                                              : "Wait",
                                          totalSpots: contest.totalSpots,
                                          filledSpots: contest.totalSpots -
                                              contest.availableSpots,
                                          isPinned: contest.pin_to_top,
                                          remainingSpots: contest.availableSpots,
                                          onButtonTap: () async {
                                            if (homeCon.debounceTimer?.isActive ??
                                                false) {
                                              homeCon.debounceTimer?.cancel();
                                            }
                                            homeCon.debounceTimer = Timer(
                                              homeCon.debounceDuration,
                                              () async {
                                                await ContestRepository
                                                    .getJoinContestPricingDetailsAPI(
                                                  context,
                                                  contestId:
                                                      contest.id.toString(),
                                                  recurringId:
                                                      contest.recurring.toString(),
                                                  entryFee: contest.entryFee,
                                                  isNavFromDescScreen: false,
                                                );
                                              },
                                            );
                                          },
                                          onTapOfContest: () {
                                            Get.toNamed(
                                              AppRoutes.contestDetailsScreen,
                                              arguments: {
                                                "contestDetailsType":
                                                    ContestDetailsType.unJoined,
                                                "contestId":
                                                    contest.id.toString(),
                                                "recurringId":
                                                    contest.recurring.toString(),
                                              },
                                            );
                                          },
                                        );
                                      }
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

  /// Custom Text Button
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
                  AppDialogs.videoInstructionDialogueFunction(
                    title: title,
                    assetVideoPath: assetVideoPath,
                    loader: loader,
                  );
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
          borderRadius: BorderRadius.circular(defaultRadius * 10),
        ),
        child: loader.isFalse
            ? Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.getColorOnBackground(
                              Theme.of(context).primaryColor),
                          fontSize: fontSize,
                        ),
                  ),
                  if (suffixSvg != null)
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding / 5),
                      child: SvgPicture.asset(
                        suffixSvg,
                        colorFilter: AppColors.iconColorFilter(context,
                            color: Colors.white),
                        width: 11.sp,
                      ),
                    ),
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
}
