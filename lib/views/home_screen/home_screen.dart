import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/app_bar.dart';
import 'package:maze_king/res/widgets/app_dialog.dart';
import 'package:maze_king/res/widgets/contest_widgets.dart';
import 'package:maze_king/views/bottombar/bottombar_controller.dart';
import 'package:maze_king/views/my_matches/my_matches_controller.dart';
import 'package:maze_king/views/my_matches/widgets/completed/my_completed_matches_screen.dart';
import '../../repositories/contest/contest_repository.dart';
import '../../res/widgets/pull_to_refresh_indicator.dart';
import '../../res/widgets/scaffold_widget.dart';
import '../contest_details/contest_details_controller.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeCon = Get.put(HomeController());
  BottomNavBarController navController = Get.put(BottomNavBarController());
  MyMatchesController myMatchesController = MyMatchesController();
  MyCompletedMatches myCompletedMatches = MyCompletedMatches();

  late String displayTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Start the timer to update the display every minute
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String convert_startDate_to_Date(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString); // Parse the date string
      final DateTime now = DateTime.now(); // Get current time
      final Duration difference =
          date.difference(now); // Calculate the difference

      if (difference.isNegative == false) {
        if (difference.inDays < 1) {
          if (difference.inHours < 1) {
            // If the time left is less than 1 hour
            final int minutes = difference.inMinutes;
            final int seconds = difference.inSeconds
                .remainder(60); // Seconds left after minutes
            return '${minutes}m ${seconds}s';
          } else {
            // If the time left is less than 1 day but more than 1 hour
            final int hours = difference.inHours;
            final int minutes =
                difference.inMinutes.remainder(60); // Minutes left after hours
            return '${hours}h ${minutes}m';
          }
        } else {
          // If the time left is more than 1 day, format as "dd MMM"
          final DateFormat formatter = DateFormat('dd MMM');
          return formatter.format(date);
        }
      } else {
        // Return "Invalid Date" if the date is in the past
        return "Invalid Date";
      }
    } catch (e) {
      // Return a fallback or error message in case of invalid date
      return "Invalid Date";
    }
  }

  void navigateToCompl() {
  try {
    // Ensure MyCompletedMatches is registered
    Get.put(MyCompletedMatches()); // or Get.lazyPut(() => MyCompletedMatches())

    // Access the BottomNavBarController
    BottomNavBarController bottomBarCon = Get.find<BottomNavBarController>();

    // Ensure the selected index is updated
    bottomBarCon.selectedScreenIndex.value = 1; // Navigate to 'My Matches'

    // Access or initialize MyMatchesController
    MyMatchesController myMatchesCon = Get.put(MyMatchesController());

    // Ensure the tab index is updated
    myMatchesCon.tabController.index = 2;

    bottomBarCon.selectedScreenIndex.refresh();

    // Trigger the onResume logic if required
    myGamesScreenOnResumeEvent();
    // Navigate to the BottomNavBarScreen
    Get.offNamed(AppRoutes.bottomNavBarScreen);
  } catch (e) {
    if (kDebugMode) {
      print("Error in navigateToCompl: $e");
      }
    }
  }

  void myGamesScreenOnResumeEvent() {
    printYellow("MyGames Screen OnResume Event");
    BottomNavBarController bottomBarCon = Get.find<BottomNavBarController>();
    MyCompletedMatches myCompletedMatches = Get.find<MyCompletedMatches>();
    MyMatchesController myMatchesCon = Get.find<MyMatchesController>();
    if (bottomBarCon.selectedScreenIndex.value == 1) {
      if (isRegistered<MyCompletedMatches>()) {
        MyCompletedMatches con = Get.find<MyCompletedMatches>();
        if (myMatchesCon.tabController.index == 2) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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

      String calculateRemainingTime(DateTime startTime) {
        final currentTime = DateTime.now();
        final difference = startTime.difference(currentTime);

        if (difference.isNegative) {
          return "Started"; // If the time has already passed
        } else {
          final hours = difference.inHours;
          final minutes = difference.inMinutes % 60;
          final seconds = difference.inSeconds % 60;

          // Format the remaining time as HH:MM:SS
          return "${hours.toString().padLeft(2, '0')}:"
              "${minutes.toString().padLeft(2, '0')}:"
              "${seconds.toString().padLeft(2, '0')}";
        }
      }

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
                  if (LocalStorage.userName != "JohnSmith")
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

                      /// testing
                      // IconButton(
                      //     onPressed: () => setState(() {
                      //           navigateToCompl();
                      //         }),
                      //     icon: const Icon(Icons.telegram))
                    ],
                  ),
                ),
              ),

              /// Contests Section
              Expanded(
                child: PullToRefreshIndicator(
                  onRefresh: () =>
                      homeCon.getContestsAPICall(isPullToRefresh: true),
                  child: homeCon.isLoading.isFalse
                      ? ListView(
                          padding: EdgeInsets.zero,
                          controller: homeCon.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            /// Contest List

                            ListView.builder(
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
                                      )?.whenComplete(
                                          () => homeCon.getContestsAPICall(
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

                                  if (LocalStorage.userName != "JohnSmith") {
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

                                      // remainingTime:
                                      //     index <= homeCon.timerList.length
                                      //         ? homeCon.timerList[(index)]
                                      //         : "Wait",

                                      remainingTime: convert_startDate_to_Date(
                                          contest.startTime.toIso8601String()),

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
                                              contestId: contest.id.toString(),
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
                                            "contestId": contest.id.toString(),
                                            "recurringId":
                                                contest.recurring.toString(),
                                          },
                                        );
                                      },
                                    );
                                  }
                                }
                                return null;
                              },
                            )
                            // : EmptyElement(
                            //     padding: EdgeInsets.symmetric(
                            //         vertical: Get.height / 3.5),
                            //     title: "Contests Not Found",
                            //   ),
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
