import 'package:flutter/cupertino.dart';

class ScrollBehaviorModified extends CupertinoScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // if (Platform.isIOS || Platform.isMacOS) {
    //   return const BouncingScrollPhysics();
    // } else {
    return CustomScrollPhysics();
    // }
  }

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      child: child,
    );
  }
}

class CustomScrollPhysics extends ClampingScrollPhysics {
  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = toleranceFor(position);
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }
}
