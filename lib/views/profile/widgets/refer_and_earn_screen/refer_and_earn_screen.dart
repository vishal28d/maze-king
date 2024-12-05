import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/app_bar.dart';
import 'package:maze_king/views/profile/components/transaction_tile.dart';
import 'package:maze_king/views/profile/widgets/refer_and_earn_screen/refer_and_earn_controller.dart';

class ReferAndEarnScreen extends StatelessWidget {
  ReferAndEarnScreen({super.key});

  final ReferAndEarnController con = Get.put(ReferAndEarnController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE4F6FF),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyAppBar(
              showBackIcon: true,
              title: "Invite Friends",
              myAppBarSize: MyAppBarSize.medium,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(defaultPadding),
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Text(
                    "How It Works",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  18.verticalSpace,
                  howWorkStepper(
                    context,
                    step: "1",
                    title: "Share code",
                    subtitle: "Friend uses your code to register",
                    isShowPath: true,
                  ),
                  howWorkStepper(
                    context,
                    step: "2",
                    title: "Friend get a discount",
                    subtitle: "Friend uses your code to register",
                    isShowPath: true,
                  ),
                  howWorkStepper(
                    context,
                    step: "3",
                    title: "You gets rewards",
                    subtitle: "When your friend adds money for the first deposit, you get 5% of their deposit up to ${AppStrings.rupeeSymbol}100",
                  ),
                  28.verticalSpace,
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
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Share your Invite Code",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2, vertical: defaultPadding / 2),
                          child: Text(
                            "When your friend adds money for the first deposit, you get 5% of their deposit up to ${AppStrings.rupeeSymbol}100",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.primary.withOpacity(0.5),
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: AppColors.whiteSmoke),
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 8.h),
                          padding: const EdgeInsets.symmetric(vertical: defaultPadding / 1.2, horizontal: defaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocalStorage.referralCode.value,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 18.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: LocalStorage.referralCode.value));
                                  UiUtils.toast("Invite Code Copied");
                                },
                                child: SvgPicture.asset(
                                  AppAssets.copyOutline,
                                  height: 20.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        18.verticalSpace,
                        AppButton(
                          onPressed: () {
                            shareAppLink(link: "Download ${AppStrings.appName} Game,\n\nLink: ${Platform.isAndroid ? AppStrings.playStoreLink : AppStrings.appStoreLink}\n\nUse '${LocalStorage.referralCode}' this referral code to avail the discounts!");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.userFilledSVG,
                                color: Colors.white,
                              ),
                              4.horizontalSpace,
                              Text(
                                "Invite Now",
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        2.verticalSpace,
                      ],
                    ),
                  ),
                  28.verticalSpace,
                  Text(
                    "Frequently Asked Questions",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  18.verticalSpace,
                  ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const RangeMaintainingScrollPhysics(),
                    itemCount: con.allQuestions.length,
                    itemBuilder: (context, index) => Obx(() {
                      return TransactionTile(
                        index: index,
                        isSubTitleOn: con.allQuestions[index]['isDesc'].value,
                        subTitle: con.allQuestions[index]['desc'],
                        title: con.allQuestions[index]['question'],
                        icon: AppAssets.dropArrowSVG,
                        onPressed: () {
                          con.allQuestions[index]['isDesc'].value = !con.allQuestions[index]['isDesc'].value;
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget howWorkStepper(BuildContext context, {required String step, required String title, required String subtitle, final bool isShowPath = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 18.h,
              width: 18.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              alignment: Alignment.center,
              child: Text(
                step,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (isShowPath)
              Container(
                height: 36.h,
                width: 2.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.36),
                ),
              ),
          ],
        ),
        16.horizontalSpace,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            4.verticalSpace,
            SizedBox(
              width: Get.width / 1.24,
              child: Text(
                subtitle,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.primary.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
