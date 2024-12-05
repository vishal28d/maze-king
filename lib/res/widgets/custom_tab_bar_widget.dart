import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/common/tab_bar_model.dart';
import '../../exports.dart';
import '../../packages/animated_counter/animated_counter.dart';

class CustomTabBar extends StatefulWidget {
  final RxList<Rx<TabBarModel>> tabList;
  final Function(int, String)? onTap;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? screenList;
  final TabController? tabController;
  final ScrollPhysics? physics;

  const CustomTabBar({
    super.key,
    required this.tabList,
    this.onTap,
    this.padding,
    this.screenList,
    this.tabController,
    this.physics,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

late String returnLabel;

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    if (widget.tabController == null) {
      return DefaultTabController(
        length: widget.tabList.length,
        child: tabWidget(),
      );
    } else {
      return tabWidget();
    }
  }

  Widget tabWidget() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: widget.padding,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              child: TabBar(
                physics: widget.physics,
                controller: widget.tabController,
                labelColor: AppColors.black,
                labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13.sp, letterSpacing: 0.8, fontWeight: FontWeight.w600, color: AppColors.black),
                unselectedLabelColor: AppColors.primary.withOpacity(0.55),
                unselectedLabelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 13.sp,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).disabledColor,
                    ),
                automaticIndicatorColorAdjustment: true,
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                dividerColor: Colors.transparent,
                indicatorColor: Theme.of(context).colorScheme.surface,
                indicatorPadding: EdgeInsets.zero,
                indicatorWeight: double.minPositive,
                padding: const EdgeInsets.all(5),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultRadius - 5),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                labelPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (index) {
                  returnLabel = widget.tabList[index].value.title ?? "";
                  if (widget.onTap != null) widget.onTap!(index, returnLabel);
                },
                tabs: List.generate(
                  widget.tabList.length,
                  (index) => Stack(
                    children: [
                      if (widget.tabList[index].value.showBadge?.value == true)
                        Align(
                          alignment: Alignment.topRight,
                          child: AnimatedSwitcher(
                            duration: defaultDuration,
                            child: widget.tabList[index].value.badgeLabel?.value != 0
                                ? CircleAvatar(
                                    radius: 9.r,
                                    child: Center(
                                      child: AnimatedFlipCounter(
                                        value: widget.tabList[index].value.badgeLabel?.value ?? 0,
                                        textStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor, fontSize: 10.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding / 1.5),
                          child: Text(
                            widget.tabList[index].value.title ?? "",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widget.screenList != null
                ? Expanded(
                    child: TabBarView(
                      controller: widget.tabController,
                      children: widget.screenList ?? [],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
