import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/tab_bar.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/my_transaction_screen_controller.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/contests_screen_controller/contests_screen.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/deposits_screen/deposits_screen.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/withdrawals_screen/withdrawals_screen.dart';

import '../../../../res/widgets/app_bar.dart';
import 'widgets/tds_transactions_screen/tds_transactions_screen.dart';

class MyTransactionsScreen extends StatelessWidget {
  MyTransactionsScreen({super.key});

  final MyTransactionScreenController con = Get.put(MyTransactionScreenController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.cyanBg,
        body: Column(
          children: [
            MyAppBar(
              showBackIcon: true,
              title: "My Transactions",
              // actions: [
              //   appBarActionButton(svgIconPath: AppAssets.filterGraphicIconSVG, onTap: () {}),
              // ],
              bottomWidget: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                // margin: EdgeInsets.only(bottom: defaultPadding),
                child: const MyTabBar(
                  backgroundColor: Colors.white,
                  // labelColor: AppColors.error,
                  // indicatorColor: AppColors.error,
                  tabs: [
                    Tab(
                      child: Text("Contest"),
                    ),
                    Tab(
                      child: Text("Withdrawals"),
                    ),
                    Tab(
                      child: Text("Deposits"),
                    ),
                    Tab(
                      child: Text("TDS"),
                    ),
                  ],
                ),
              ),
              bottomWidgetWidth: Get.width * 0.95,
            ),
            8.verticalSpace,
            Expanded(
              child: TabBarView(
                children: [
                  ContestsScreen(),
                  WithdrawalsScreen(),
                  DepositsScreen(),
                  TdsTransactionsScreen(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
