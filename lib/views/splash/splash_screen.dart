import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/auth_background_widget.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController con = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SvgPicture.asset(
            AppAssets.logoSVG,
            height: Get.width * .50,
            width: Get.width * .50,
          ),
        ),
      ),
    );
  }
}
