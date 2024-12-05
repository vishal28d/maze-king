import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';

import '../../../packages/cached_network_image/cached_network_image.dart';

class ProfileDetailAppBar extends StatelessWidget {
  final String? imgUrl;
  final String title;
  final String subTitle;
  final bool showBackIcon;
  final Color backGroundColor;

  const ProfileDetailAppBar({
    super.key,
    required this.title,
    required this.subTitle,
    this.showBackIcon = false,
    this.imgUrl,
    this.backGroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 217.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.authSmallBgPNG),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
      alignment: Alignment.center,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            6.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                showBackIcon
                    ? GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5),
                          // color: Colors.green,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: defaultPadding / 0.7),
                        child: SizedBox(),
                      ),
                (LocalStorage.userImage.value.startsWith(AppStrings.httpPrefix) || LocalStorage.userImage.value.startsWith(AppStrings.httpsPrefix))
                    ? AppNetworkImage(
                        height: 80.h,
                        width: 80.h,
                        borderRadius: BorderRadius.circular(10.r),
                        imageUrl: imgUrl ?? "",
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 80.h,
                        width: 80.h,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(defaultRadius),
                          image: DecorationImage(
                            image: FileImage(
                              File(LocalStorage.userImage.value),
                            ),
                          ),
                        ),
                      ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding / 0.7),
                  child: SizedBox(),
                )
              ],
            ),
            8.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            8.verticalSpace,
            Container(
              decoration: BoxDecoration(color: backGroundColor, borderRadius: BorderRadius.circular(50.r)),
              padding: EdgeInsets.symmetric(horizontal: backGroundColor == Colors.transparent ? 0 : defaultPadding / 1.3, vertical: backGroundColor == Colors.transparent ? 0 : defaultPadding /5 ).copyWith(bottom: 2.h,top: 2..h),
              child: Text(
                subTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
