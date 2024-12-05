import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_assets.dart';

class AuthBackgroundWidget extends StatelessWidget {
  final Widget child;

  const AuthBackgroundWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.authBgPNG),
          fit: BoxFit.cover,
        ),
        gradient: RadialGradient(
          stops: const [.001, 1],
          radius: Get.height / 1000,
          colors: [
            const Color(0xff2C377D),
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: child,
    );
  }
}

class AuthSmallBackgroundWidget extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final bool isOrangeBg;

  const AuthSmallBackgroundWidget({
    super.key,
    required this.child,
    this.bgColor,
    this.isOrangeBg = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(isOrangeBg ? AppAssets.authSmallOrangeBgPNG : AppAssets.authSmallBgPNG),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
        color: bgColor ?? Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
