import 'package:flutter/material.dart';
import '../../exports.dart';

class AppScaffoldBgWidget extends StatelessWidget {
  final Widget child;
  final double? opacity;
  final Color? bgColor;

  const AppScaffoldBgWidget({
    super.key,
    required this.child,
    this.opacity,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.scaffoldBgImagePNG),
          fit: BoxFit.cover,
          opacity: opacity ?? 0.8,
        ),
        color: bgColor ?? Colors.transparent,
      ),
      child: child,
    );
  }
}
