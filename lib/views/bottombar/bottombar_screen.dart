import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/packages/fluid_bottombar/fluid_bottom_nav_bar.dart';
import 'package:maze_king/repositories/wallet/wallet_repository.dart';
import 'package:maze_king/views/home_screen/home_controller.dart';
import 'package:maze_king/views/profile/profile_controller.dart';
import 'package:maze_king/views/winners/winners_screen_controller.dart';
import '../../exports.dart';
import '../../repositories/winners/winners_repository.dart';
import '../my_matches/my_matches_controller.dart';
import '../my_matches/widgets/upcoming/my_upcoming_matches_controller.dart';
import 'bottombar_controller.dart';

class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({super.key});

  final BottomNavBarController con = Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          // backgroundColor: Theme.of(context).primaryColor,
          body: Container(
            padding: const EdgeInsets.only(bottom: 0),
            child: con.screenViewByIndex(),
          ),

          /// BottomBar
          bottomNavigationBar: Container(
            // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(AppAssets.demoBgPNG), fit: BoxFit.cover, opacity: 0.9),
              // border: Border(
              //     // bottom: BorderSide(color: AppColors.whiteSmoke, width: 1),
              //     ),
            ),
            child: FluidNavBar(
              selectedTabBgColor: con.selectedScreenIndex.value > 2 ? AppColors.cyanBg : Colors.transparent,
              animationFactor: 0.5,
              defaultIndex: con.selectedScreenIndex.value,
              style: FluidNavBarStyle(
                barBackgroundColor: Theme.of(context).primaryColor,
                iconBackgroundColor: Colors.transparent,
              ),
              icons: [
                FluidNavBarIcon(
                  title: "Home",
                  svgUnSelectedPath: AppAssets.homeUnselectedGraphicSVG,
                  svgSelectedPath: AppAssets.homeSelectedGraphicSVG,
                ),
                FluidNavBarIcon(
                  title: "My Games",
                  svgUnSelectedPath: AppAssets.myMatchesUnselectedGraphicSVG,
                  svgSelectedPath: AppAssets.myMatchesSelectedGraphicSVG,
                ),
                FluidNavBarIcon(
                  title: "Winners",
                  svgUnSelectedPath: AppAssets.winnersUnselectedGraphicSVG,
                  svgSelectedPath: AppAssets.winnersSelectedGraphicSVG,
                ),
                FluidNavBarIcon(
                  title: "Profile",
                  svgUnSelectedPath: AppAssets.profileUnselectedGraphicSVG,
                  svgSelectedPath: AppAssets.profileSelectedGraphicSVG,
                ),
              ],
              onChange: (int index) {
                con.selectedScreenIndex.value = index;
                HapticFeedback.lightImpact();

                /// home screen
                switch (index) {
                  case 0:

                    /// Home
                    if (isRegistered<HomeController>()) {
                      HomeController con = Get.find<HomeController>();
                      con.getContestsAPICall(isPullToRefresh: true);
                    }
                  case 1:

                    /// My Games

                    if (isRegistered<MyMatchesController>()) {
                      MyMatchesController con = Get.find<MyMatchesController>();

                      if (isRegistered<MyUpcomingMatchesController>()) {
                        MyUpcomingMatchesController upCon = Get.find<MyUpcomingMatchesController>();

                        if (con.tabController.index == 0) {
                          upCon.getContestsAPICall(isPullToRefresh: true, isLoader: upCon.isLoading);
                        } else {
                          con.tabController.index = 0;
                        }
                      } else {}
                    }

                  case 2:

                    /// Winners
                    if (isRegistered<WinnersScreenController>()) {
                      WinnersRepository.allWinnersAPI(isPullToRefresh: true);
                    }
                  case 3:

                    /// Profile
                    if (isRegistered<ProfileController>()) {
                      WalletRepository.getWalletDetailsAPI();
                    }
                }
              },
            ),
          ),
        ),
      );
    });
  }

  BottomNavigationBarItem bottomNavigationBarItem(
    BuildContext context, {
    required String label,
    required int index,
    required String selectedSvgPath,
    required String unSelectedSvgPath,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        margin: EdgeInsets.only(top: 3.h),
        child: SvgPicture.asset(
          index == con.selectedScreenIndex.value ? selectedSvgPath : unSelectedSvgPath,
          // ignore: deprecated_member_use
          // color: index == con.selectedScreenIndex.value ? Theme.of(context).bottomNavigationBarTheme.selectedIconTheme?.color : AppColors.subTextColor(context) /*Theme.of(Get.context!).bottomNavigationBarTheme.unselectedIconTheme?.color*/,
          height: 20.w,
        ),
      ),
      label: label,
    );
  }
  

}
