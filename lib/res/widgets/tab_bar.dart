import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../exports.dart';

class MyTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final Color? backgroundColor;
  final Color? labelColor;
  final double? width;
  final double? borderRadius;
  final TabAlignment? tabAlignment;
  final TabController? controller;

  const MyTabBar({super.key, this.width, this.borderRadius, this.controller, this.tabAlignment, required this.tabs, this.backgroundColor, this.labelColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width,
      decoration: BoxDecoration(color: backgroundColor ?? Theme.of(context).cardColor, borderRadius: BorderRadius.circular(borderRadius ?? defaultRadius)),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: tabAlignment ?? TabAlignment.center,
        dividerColor: Colors.transparent,
        labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: labelColor ?? Theme.of(context).primaryColor,
            ),
        unselectedLabelColor: AppColors.subTextColor(context),
        tabs: tabs,
      ),
    );
  }
}
