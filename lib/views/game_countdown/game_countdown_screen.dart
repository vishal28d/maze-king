import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/res/widgets/contest_widgets.dart';
import 'package:maze_king/views/game_countdown/game_countdown_controller.dart';
import '../../exports.dart';
import '../../res/widgets/app_bar.dart';

class GameCountdownScreen extends StatelessWidget {
  GameCountdownScreen({super.key});

  final GameCountdownController con = Get.put(GameCountdownController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.cyanBg,
        body: Column(
          children: [
            /// AppBar
            MyAppBar(
              showBackIcon: true,
              title: "Count Down",
              myAppBarSize: MyAppBarSize.medium,
              backgroundColor: Colors.transparent,
            ),

            /// Contests
            Expanded(
              child: con.isLoading.isFalse
                  ? ListView(
                      physics: const RangeMaintainingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        (Get.width / 4).verticalSpace,

                        /// Contest details
                        Center(
                          child: Text(
                            con.remainingTime.value,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 50.sp, fontWeight: FontWeight.w900),
                          ),
                        ),
                        // 10.verticalSpace,
                        Center(
                          child: Text(
                            "Game Starts In",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12.sp, color: AppColors.subTextColor(context)),
                          ),
                        ),
                        10.verticalSpace,
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Text(
                              "Get ready! You will be redirected to the game as soon as the countdown finishes. Prepare yourself for an exciting maze challenge!",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: /*Theme.of(context).colorScheme.tertiary*/ AppColors.green,
                                  ),
                            ),
                          ),
                        ),

                        // AppButton(
                        //     title: "Practice Game",
                        //     padding: const EdgeInsets.all(defaultPadding),
                        //     onPressed: () {
                        //       Get.toNamed(AppRoutes.gameViewScreen, arguments: {
                        //         "isFreePracticeMode": true,
                        //       });
                        //     }),
                        if (con.remainingTimeInSec.value > 10)
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: AppContestWidgets.freePracticeContest(
                              context,
                              onButtonTap: () {
                                /// Delete GameViewController
                                deleteGameViewController();

                                Get.toNamed(AppRoutes.gameViewScreen, arguments: {
                                  "isFreePracticeMode": true,
                                  "isNavFromCuntDownScreen": true,
                                  "gameStartCountDownRemainingMilliseconds": con.contestDetailsModel.value.upcomingRemainingMilliSeconds,
                                  "gameStartDateTimeForCountDown": con.contestDetailsModel.value.startTime,
                                });
                              },
                              onTapOfContest: () {},
                            ),
                          ),
                      ],
                    )
                  : UiUtils.appCircularProgressIndicator(),
            ),
          ],
        ),
      );
    });
  }
}
