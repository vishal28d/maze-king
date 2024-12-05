import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/packages/cached_network_image/cached_network_image.dart';
import 'package:maze_king/res/empty_element.dart';
import 'package:maze_king/res/widgets/app_bar.dart';
import 'package:maze_king/res/widgets/pull_to_refresh_indicator.dart';
import 'package:maze_king/res/widgets/scaffold_widget.dart';
import 'package:maze_king/views/winners/winners_screen_controller.dart';

import '../../exports.dart';
import '../../repositories/winners/winners_repository.dart';

class WinnersScreen extends StatelessWidget {
  WinnersScreen({super.key});

  final WinnersScreenController con = Get.put(WinnersScreenController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldBgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            MyAppBar(
              backgroundColor: Colors.transparent,
              title: "Winners",
              myAppBarSize: MyAppBarSize.medium,
            ),
            Obx(() {
              return Expanded(
                child: PullToRefreshIndicator(
                  onRefresh: () async {
                    await WinnersRepository.allWinnersAPI(
                        isPullToRefresh: true);
                  },
                  child: con.isLoader.isFalse
                      ? ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          children: [
                            if (con.allWinners.isEmpty)
                              EmptyElement(
                                title: "No Winners Yet",
                                padding: EdgeInsets.symmetric(
                                    vertical: Get.height / 3),
                              )
                            else
                              GridView.builder(
                                shrinkWrap: true,
                                controller: con.scrollController,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    top: defaultPadding,
                                    bottom: defaultPadding),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: defaultPadding,
                                  mainAxisSpacing: defaultPadding,
                                  mainAxisExtent: Get.width / 2.85,
                                ),
                                itemCount: con.allWinners.length,
                                itemBuilder: (context, index) {
                                  return playerDetailCard(
                                    context,
                                    isCurrentUser: con.allWinners[index].id ==
                                        LocalStorage.userId.value,
                                    index: index,
                                    title: con.allWinners[index].id ==
                                            LocalStorage.userId.value
                                        ? "You"
                                        : "${con.allWinners[index].userName}",
                                    imageUrl: "${con.allWinners[index].image}",
                                    score:
                                        "${con.allWinners[index].skillScore}",
                                    isDisable: con.allWinners[index].id ==
                                        LocalStorage.userId.value,
                                    onPressed: () {
                                      printOkStatus(con.allWinners[index]);
                                      Get.toNamed(
                                        AppRoutes.comparisonScreen,
                                        arguments: {
                                          "userId": con.allWinners[index].id
                                        },
                                      );
                                    },
                                  );
                                },
                              )
                          ],
                        )
                      : UiUtils.appCircularProgressIndicator(),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget playerDetailCard(BuildContext context,
      {required int index,
      required bool isCurrentUser,
      bool isDisable = false,
      String? imageUrl,
      String? title,
      String? score,
      VoidCallback? onPressed}) {
    return InkWell(
      splashColor: AppColors.black.withOpacity(0.06),
      borderRadius: BorderRadius.circular(8.r),
      onTap: isDisable ? null : onPressed,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Theme.of(context).colorScheme.secondary.withOpacity(0.6)
                : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Stack(
            children: [
              Container(
                // height: Get.height/6,
                padding: EdgeInsets.all(Get.width / 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Get.width / 4.8,
                      width: Get.width / 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r)),
                      child: AppNetworkImage(
                        imageUrl: imageUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                    7.verticalSpace,
                    Text(
                      title ?? "-",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 11.3.sp,
                            color: AppColors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    2.verticalSpace,
                    Text(
                      "Score: ${score ?? 0}",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              if (index < 3)
                Positioned(
                  left: 4.sp,
                  child: SvgPicture.asset(
                    index == 0
                        ? AppAssets.rankOneSVG
                        : index == 1
                            ? AppAssets.rankTwoSVG
                            : AppAssets.rankThreeSVG,
                    width: Get.width / 15,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
