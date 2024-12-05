import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../exports.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final Color? backgroundColor;
  final Color? imageColor;
  final Color? imageBorderColor;
  final Alignment? alignment;
  final FilterQuality filterQuality;
  final BoxShape shape;
  final BlendMode? blendMode;
  final double? height;
  final double? width;
  final double? borderWidth;
  final double? indicatorSize;
  final double? indicatorStrokeWidth;
  final bool? showProgressIndicator;
  final Duration? fadeInDuration;
  final VoidCallback? onTap;
  final Duration? placeholderFadeInDuration;
  final Duration? fadeOutDuration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
    this.backgroundColor,
    this.imageBorderColor,
    this.alignment,
    this.filterQuality = FilterQuality.low,
    this.shape = BoxShape.rectangle,
    this.indicatorSize = 25.0,
    this.indicatorStrokeWidth,
    this.showProgressIndicator,
    this.onTap,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.placeholderFadeInDuration,
    this.margin,
    this.padding,
    this.borderRadius,
    this.imageColor,
    this.borderWidth,
    this.blendMode,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        clipBehavior: Clip.antiAlias,
        margin: padding,
        padding: margin,
        decoration: BoxDecoration(
          // color: Colors.red,
          shape: shape,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: !isValEmpty(imageUrl)
            ? ClipRRect(
          borderRadius: borderRadius??BorderRadius.circular(defaultRadius),
              child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  alignment: alignment ?? Alignment.center,
                  fit: fit,
                  height: height,
                  width: width,
                  color: imageColor,
                  maxHeightDiskCache: 999,
                  maxWidthDiskCache: 999,
                  memCacheHeight: 999,
                  memCacheWidth: 999,
                  filterQuality: filterQuality,
                  fadeOutDuration: fadeOutDuration ?? const Duration(microseconds: 1),
                  placeholderFadeInDuration: placeholderFadeInDuration ?? const Duration(microseconds: 1),
                  fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 500),
                  progressIndicatorBuilder: (showProgressIndicator ?? false
                      ? (context, url, progress) => Center(
                            child: SizedBox(
                              height: indicatorSize,
                              width: indicatorSize,
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: indicatorStrokeWidth ?? 2.0, value: progress.progress),
                              ),
                            ),
                          )
                      : null),
                  placeholder: (showProgressIndicator ?? true ? (context, url) => ShimmerUtils.shimmer(child: ShimmerUtils.shimmerContainer(width: width, height: height ?? Get.height * 0.225, borderRadius: defaultRadius)) : null),
                  errorWidget: (context, url, error) => Container(
                    height: height ?? Get.height * 0.225,
                    width: width,
                    color: Theme.of(context).iconTheme.color!.withAlpha(30),
                    padding: const EdgeInsets.all(defaultPadding * 2),
                    child: kDebugMode
                        ? Center(
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Colors.grey[800],
                            ),
                          )
                        : null,
                  ),
                ),
            )
            : Container(
                height: height ?? Get.height * 0.225,
                width: width,
                color: Theme.of(context).iconTheme.color!.withAlpha(30),
                padding: const EdgeInsets.all(defaultPadding * 2),
                child: kDebugMode
                    ? Center(
                        child: Text(
                          'URL not found!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : null,
              ),
      ),
    );
  }
}
