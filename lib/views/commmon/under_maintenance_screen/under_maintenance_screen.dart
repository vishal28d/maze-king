import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../exports.dart';

class UnderMaintenanceScreen extends StatelessWidget {
  const UnderMaintenanceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                imageWidget,
                const Spacer(),
                titleWidget,
                const SizedBox(height: defaultPadding / 2),
                subTitleWidget,
                const Spacer(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get imageWidget {
    return Image.asset(
      AppAssets.underMaintenancePNG,
      width: Get.width,
      height: Get.width / 1.5,
    );
  }

  Widget get titleWidget {
    return Text(
      "App is under maintenance",
      textAlign: TextAlign.center,
      style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
    );
  }

  Widget get subTitleWidget {
    return Text(
      "We're currently under maintenance to improve the app experience. Be back soon!",
      textAlign: TextAlign.center,
      style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
    );
  }
}
