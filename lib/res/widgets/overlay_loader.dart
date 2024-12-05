import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maze_king/exports.dart';

class OverlayLoader {
  static OverlayEntry? _overlayEntry;

  static void showLoader(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withOpacity(0.5),
            dismissible: false,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2, vertical: defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                  (defaultPadding).horizontalSpace,
                  Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (!isValEmpty(_overlayEntry)) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  static void hideLoader() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}
