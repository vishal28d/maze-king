import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';

import '../../../../res/widgets/app_bar.dart';
import 'kyc_detail_screen_controller.dart';

class KycDetailScreen extends StatelessWidget {
  KycDetailScreen({super.key});

  final KycDetailScreenController con = Get.put(KycDetailScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(() {
        return Column(
          children: [
            MyAppBar(
              showBackIcon: true,
              title: "My KYC Details",
              myAppBarSize: MyAppBarSize.medium,
              backgroundColor: Colors.transparent,
            ),
            con.isLoader.value
                ? Expanded(
                    child: UiUtils.appCircularProgressIndicator(),
                  )
                : ListView(
                    shrinkWrap: true,
                    physics: const RangeMaintainingScrollPhysics(),
                    // padding: const EdgeInsets.all(defaultPadding).copyWith(bottom: (defaultPadding * 4 + 46.w)),
                    children: [
                      detailTile(
                        context,
                        title: "Bank Details",
                        icon: AppAssets.bankOutlineSVG,
                        topRadius: true,
                        bottomRadius: true,
                        onPressed: () {
                          if (con.panCardVerify.value) {
                            Get.toNamed(AppRoutes.bankDetailScreen);
                          } else {
                            UiUtils.toast("Please verify pan card first");
                          }
                        },
                      ),
                      (defaultPadding / 2).verticalSpace,
                      detailTile(
                        context,
                        title: "Pan Card Details",
                        icon: AppAssets.termsAndConditionSVG,
                        topRadius: true,
                        bottomRadius: true,
                        onPressed: () {
                          Get.toNamed(AppRoutes.panCardDetailScreen)?.whenComplete(() {
                            con.initApi();
                          });
                        },
                      ),
                    ],
                  ),
          ],
        );
      }),
    );
  }

  Widget detailTile(BuildContext context, {required String title, required String icon, final bool topRadius = false, final bool bottomRadius = false, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: AppColors.authSubTitle.withOpacity(0.4),
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(topRadius ? 10.r : 0),
            bottom: Radius.circular(bottomRadius ? 10.r : 0),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.h).copyWith(right: 12.h),
              child: SvgPicture.asset(icon),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
