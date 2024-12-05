import 'package:get/get.dart';
import 'package:maze_king/views/authentication/add_username/add_username_screen.dart';
import 'package:maze_king/views/authentication/mobile_auth/mobile_auth_screen.dart';
import 'package:maze_king/views/authentication/otp_verification/otp_verification_screen.dart';
import 'package:maze_king/views/contest_details/contest_details_screen.dart';
import 'package:maze_king/views/game_view_screen/game_view_screen.dart';
import 'package:maze_king/views/profile/widgets/add_cash_screen/add_cash_screen.dart';
import 'package:maze_king/views/profile/widgets/bank_detail_screen/bank_detail_screen.dart';
import 'package:maze_king/views/profile/widgets/info_and_setting_screen/info_and_setting_screen.dart';
import 'package:maze_king/views/profile/widgets/more_screen/more_screen.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/my_transactions_screen.dart';
import 'package:maze_king/views/profile/widgets/refer_and_earn_screen/refer_and_earn_screen.dart';
import 'package:maze_king/views/profile/widgets/wallet_screen/wallet_screen.dart';
import 'package:maze_king/views/profile/widgets/withdraw_screen/withdraw_screen.dart';
import 'package:maze_king/views/winners/widgets/winners_comparison_screen.dart';

import '../views/bottombar/bottombar_screen.dart';
import '../views/commmon/state_selection/select_state_screen.dart';
import '../views/commmon/under_maintenance_screen/under_maintenance_screen.dart';
import '../views/game_countdown/game_countdown_screen.dart';
import '../views/on_boarding/on_boarding_screen.dart';
import '../views/profile/widgets/kyc_details_screen/kyc_detail_screen.dart';
import '../views/profile/widgets/pan_card_details_screen/pan_card_detail_screen.dart';
import '../views/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.bottomNavBarScreen,
      page: () => BottomNavBarScreen(),
    ),
    GetPage(
      name: AppRoutes.gameCountdownScreen,
      page: () => GameCountdownScreen(),
    ),
    GetPage(
      name: AppRoutes.gameViewScreen,
      page: () => const MazeGameViewScreen(),
    ),
    GetPage(
      name: AppRoutes.mobileAuthScreen,
      page: () => MobileAuthScreen(),
    ),
    GetPage(
      name: AppRoutes.otpVerificationScreen,
      page: () => OtpVerificationScreen(),
    ),
    GetPage(
      name: AppRoutes.addUserNameScreen,
      page: () => AddUserNameScreen(),
    ),
    // GetPage(
    //   name: AppRoutes.homeScreen,
    //   page: () => HomeScreen(),
    // ),
    GetPage(
      name: AppRoutes.contestDetailsScreen,
      page: () => ContestDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.onBoardingScreen,
      page: () => OnBoardingScreen(),
    ),
    GetPage(
      name: AppRoutes.referAndEarnScreen,
      page: () => ReferAndEarnScreen(),
    ),
    GetPage(
      name: AppRoutes.myInfoAndSettingScreen,
      page: () => MyInfoAndSettingScreen(),
    ),
    GetPage(
      name: AppRoutes.kycDetailScreen,
      page: () => KycDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.bankDetailScreen,
      page: () => BankDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.panCardDetailScreen,
      page: () => PanCardDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.myTransactionsScreen,
      page: () => MyTransactionsScreen(),
    ),
    GetPage(
      name: AppRoutes.addCashScreen,
      page: () => AddCashScreen(),
    ),
    GetPage(
      name: AppRoutes.withdrawScreen,
      page: () => WithdrawScreen(),
    ),
    GetPage(
      name: AppRoutes.walletScreen,
      page: () => WalletScreen(),
    ),
    GetPage(
      name: AppRoutes.moreScreen,
      page: () => MoreScreen(),
    ),
    GetPage(
      name: AppRoutes.comparisonScreen,
      page: () => WinnersComparisonScreen(),
    ),
    GetPage(
      name: AppRoutes.underMaintenanceScreen,
      page: () => const UnderMaintenanceScreen(),
    ),
    GetPage(
      name: AppRoutes.selectStateScreen,
      page: () => SelectStateScreen(),
    ),
  ];
}
