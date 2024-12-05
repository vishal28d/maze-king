import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../exports.dart';

class TransactionShimmer extends StatelessWidget {
  const TransactionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: const EdgeInsets.all(defaultRadius),
      child: Row(
        children: [
          ShimmerUtils.shimmer(
            child: ShimmerUtils.shimmerContainer(
              height: 45.h,
              width: 45.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius / 1.4),
                color: AppColors.primary.withOpacity(.2),
              ),
            ),
          ),
          10.horizontalSpace,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerUtils.shimmer(
                child: ShimmerUtils.shimmerContainer(
                  height: 14.h,
                  width: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultRadius / 2),
                    color: AppColors.primary.withOpacity(.2),
                  ),
                ),
              ),
              6.verticalSpace,
              ShimmerUtils.shimmer(
                child: ShimmerUtils.shimmerContainer(
                  height: 14.h,
                  width: 150.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultRadius / 2),
                    color: AppColors.primary.withOpacity(.2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
