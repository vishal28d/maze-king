import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/packages/cached_network_image/cached_network_image.dart';
import 'package:maze_king/views/profile/components/profile_detail_app_bar.dart';
import 'package:maze_king/views/winners/widgets/winners_comparison_screen_controller.dart';

import '../../../packages/marquee_widget/marquee_widget.dart';

class WinnersComparisonScreen extends StatelessWidget {
  WinnersComparisonScreen({super.key});

  final WinnersComparisonScreenController con = Get.put(WinnersComparisonScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          backgroundColor: AppColors.cyanBg,
          body: con.isLoader.isFalse
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileDetailAppBar(
                      showBackIcon: true,
                      title: "${con.compare.value.you?.userName}",
                      subTitle: "Skill Score: ${con.compare.value.you?.skillScore}",
                      imgUrl: "${con.compare.value.you?.image}",
                      backGroundColor: Colors.white.withOpacity(.13),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(defaultPadding),
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          Text(
                            "Career Stats",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 17.sp,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          10.verticalSpace,
                          Container(
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: AppColors.authSubTitle.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                oppositePlayerDetails,
                                10.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: Get.width / 7,
                                      ),
                                      20.verticalSpace,
                                      Text(
                                        "",
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              color: AppColors.green,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2.6,
                                            ),
                                      ),
                                      20.verticalSpace,
                                      Text(
                                        "Skill Score",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontSize: 12.5.sp,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: .4,
                                            ),
                                      ),
                                      20.verticalSpace,
                                      Text(
                                        "Contests",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontSize: 12.5.sp,
                                              color: AppColors.black.withOpacity(.6),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: .4,
                                            ),
                                      ),
                                      20.verticalSpace,
                                      Text(
                                        "Winning Ratio",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontSize: 12.5.sp,
                                              color: AppColors.black.withOpacity(.6),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: .4,
                                            ),
                                      ),
                                      20.verticalSpace,
                                      Text(
                                        "Playing Since",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontSize: 12.5.sp,
                                              color: AppColors.black.withOpacity(.6),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: .4,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.horizontalSpace,
                                myDetails,
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : UiUtils.appCircularProgressIndicator(),
        );
      },
    );
  }

  Color getBgColor({bool isMyDetails = false, bool isOriginal = false}) {
    Color green = AppColors.green.withOpacity(isOriginal ? 1 : 0.1);
    Color red = AppColors.error.withOpacity(isOriginal ? 1 : 0.1);
    return ((con.compare.value.otherUser?.skillScore ?? 0).isEqual(con.compare.value.you?.skillScore ?? 0))
        ? green
        : (con.compare.value.otherUser?.skillScore ?? 0).isGreaterThan(con.compare.value.you?.skillScore ?? 0)
            ? isMyDetails
                ? red
                : green
            : isMyDetails
                ? green
                : red;
  }

  // Widget get firstUser => ((con.compare.value.otherUser?.skillScore ?? 0).isEqual(con.compare.value.you?.skillScore ?? 0))
  //     ? oppositePlayerDetails
  //     : (con.compare.value.otherUser?.skillScore ?? 0).isGreaterThan(con.compare.value.you?.skillScore ?? 0)
  //         ? oppositePlayerDetails
  //         : myDetails;
  //
  // Widget get secondUser => ((con.compare.value.otherUser?.skillScore ?? 0).isEqual(con.compare.value.you?.skillScore ?? 0))
  //     ? myDetails
  //     : (con.compare.value.otherUser?.skillScore ?? 0).isGreaterThan(con.compare.value.you?.skillScore ?? 0)
  //         ? myDetails
  //         : oppositePlayerDetails;

  Widget get oppositePlayerDetails => Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: getBgColor(isMyDetails: false),
            borderRadius: BorderRadius.circular(6.r),
          ),
          padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding / 2),
          child: Column(
            children: [
              SizedBox(
                height: Get.width / 7,
                width: Get.width / 7,
                child: AppNetworkImage(
                  imageUrl: "${con.compare.value.otherUser?.image}",
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              20.verticalSpace,
              MarqueeWidget(
                child: Text(
                  "${con.compare.value.otherUser?.userName}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.black.withOpacity(.6),
                        fontWeight: FontWeight.w500,
                        letterSpacing: .4,
                      ),
                ),
              ),
              25.verticalSpace,
              MarqueeWidget(
                child: Text(
                  "${con.compare.value.otherUser?.skillScore}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                        color: getBgColor(isMyDetails: false, isOriginal: true),
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        letterSpacing: 1,
                      ),
                ),
              ),
              20.verticalSpace,
              Text(
                "${con.compare.value.otherUser?.contest}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .4,
                    ),
              ),
              20.verticalSpace,
              Text(
                "${con.compare.value.otherUser?.winningRatio}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .4,
                    ),
              ),
              20.verticalSpace,
              Text(
                dateFormat(date: DateTime(con.compare.value.otherUser?.createdAt?.year ?? 0, con.compare.value.otherUser?.createdAt?.month ?? 0)),
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .4,
                    ),
              ),
            ],
          ),
        ),
      );

  Widget get myDetails => Expanded(
        child: Container(
          decoration: BoxDecoration(color: getBgColor(isMyDetails: true), borderRadius: BorderRadius.circular(6.r)),
          padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding / 2),
          child: Column(
            children: [
              SizedBox(
                height: Get.width / 7,
                width: Get.width / 7,
                child: AppNetworkImage(
                  imageUrl: "${con.compare.value.you?.image}",
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              20.verticalSpace,
              Text(
                "You",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.black.withOpacity(.6),
                      fontWeight: FontWeight.w500,
                      letterSpacing: .4,
                    ),
              ),
              25.verticalSpace,
              MarqueeWidget(
                child: Text(
                  "${con.compare.value.you?.skillScore}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                        color: getBgColor(isMyDetails: true, isOriginal: true),
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        letterSpacing: 1,
                      ),
                ),
              ),
              20.verticalSpace,
              Text(
                "${con.compare.value.you?.contest}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .4,
                    ),
              ),
              20.verticalSpace,
              Text(
                "${con.compare.value.you?.winningRatio}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .4,
                    ),
              ),
              20.verticalSpace,
              Text(
                dateFormat(date: DateTime(con.compare.value.you?.createdAt?.year ?? 0, con.compare.value.you?.createdAt?.month ?? 0)),
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .4,
                    ),
              ),
            ],
          ),
        ),
      );
}
