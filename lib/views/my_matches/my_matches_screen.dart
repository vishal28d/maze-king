import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../exports.dart';
import '../../res/widgets/app_bar.dart';
import '../../res/widgets/scaffold_widget.dart';
import '../../res/widgets/tab_bar.dart';
import 'my_matches_controller.dart';
import 'widgets/completed/my_completed_matches_screen.dart';
import 'widgets/live/my_live_matches_screen.dart';
import 'widgets/upcoming/my_upcoming_matches_screen.dart';

class MyMatchesScreen extends StatelessWidget {
  MyMatchesScreen({super.key});

  final MyMatchesController con = Get.put(MyMatchesController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldBgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            /// AppBar
            MyAppBar(
              title: AppStrings.myGames,
              // showBackIcon: true,
              // backgroundColor: Colors.transparent,
              actions: const [
                // appBarActionButton(svgIconPath: AppAssets.notificationGraphicSVG, rightPadding: 0, onTap: () {}),
                // appBarActionButton(svgIconPath: AppAssets.walletGraphicSVG, onTap: () {}),
                //  IconButton(onPressed: ()=> Get.to(MyMatchesScreen(), ), icon: const Icon(Icons.telegram , color: Colors.white,)) , 
     
                 // In some widget/button inside another screen:

// ElevatedButton(
//   onPressed: () {
//     final BottomNavBarController navController = Get.put(BottomNavBarController());
//     navController.selectedScreenIndex.value = 1; // Set index to My Games (1)

//     // Optionally, add additional logic for refreshing the data
//     if (isRegistered<MyMatchesController>()) {
//       MyMatchesController matchesController = Get.find<MyMatchesController>();

//       // Set the tabController to index 1 (Live tab)
//       matchesController.tabController.index = 1;

//       // Trigger live match data refresh if necessary
//       if (isRegistered<MyLiveMatchesController>()) {
//         MyLiveMatchesController liveMatchesController = Get.find<MyLiveMatchesController>();
//         liveMatchesController.getContestsAPICall(isPullToRefresh: true, isLoader: liveMatchesController.isLoading);
//       }
//     }
//   },
//   child: Text('Go to My Games - Live'),
// )

              ],
              bottomWidget: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LocalStorage.userName !="JohnSmith" ?  MyTabBar(
                  controller: con.tabController,

                  // backgroundColor: Colors.red,
                  tabs: [
                    Tab(
                      child: Text(AppStrings.upcoming),
                    ),
                    Tab(
                      child: Text(AppStrings.live),
                    ),
                    Tab(
                      child: Text(AppStrings.completed),
                    ),
                  ],
                ) : const SizedBox()  ,
              ),
              bottomWidgetWidth: Get.width * 0.85,
            ),

            Expanded(
              child: TabBarView(
                controller: con.tabController,
                children: [
                  MyUpcomingMatchesScreen(),
                  MyLiveMatches(),
                  MyCompletedMatches(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
