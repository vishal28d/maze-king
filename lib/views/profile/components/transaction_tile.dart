import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../exports.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool isSubTitleOn;
  final VoidCallback? onPressed;
  final int index;
  final String icon;

  const TransactionTile({super.key, this.index = 0, this.subTitle, required this.title, this.onPressed, required this.icon, this.isSubTitleOn = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        curve: Curves.easeIn,
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.all(defaultPadding),
        margin: const EdgeInsets.only(bottom: defaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: AppColors.authSubTitle.withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.black,
                          fontWeight: isSubTitleOn ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                  // 2.verticalSpace,
                  if (isSubTitleOn)
                    Padding(
                      padding: const EdgeInsets.only(top: defaultPadding / 3),
                      child: Text(
                        subTitle ?? '',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.primary.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: defaultPadding / 2),
              child: SizedBox(
                height: 15.h,
                child: isSubTitleOn
                    ? SvgPicture.asset(
                        AppAssets.upArrow,
                        color: AppColors.black,
                      )
                    : SvgPicture.asset(
                        icon,
                        color: AppColors.black,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
