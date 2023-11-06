library flip_transition;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class TiltTransition extends AnimatedWidget {
  /// Creates a tile transition.
  ///
  /// The [turns] argument must not be null.
  const TiltTransition({
    super.key,
    required Animation<double> tilts,
    this.filterQuality,
    this.child,
  }) : super(listenable: tilts);

  /// The animation that controls the tilt of the child.
  ///
  /// If the current value of the turns animation is v, the child will be
  /// tilted v as a proportion of 180 degrees (0.5 is 90 degrees) before being painted.
  Animation<double> get tilts => listenable as Animation<double>;

  /// The filter quality with which to apply the transform as a bitmap operation.
  ///
  /// When the animation is stopped (either in [AnimationStatus.dismissed] or
  /// [AnimationStatus.completed]), the filter quality argument will be ignored.
  ///
  /// {@macro flutter.widgets.Transform.optional.FilterQuality}
  final FilterQuality? filterQuality;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // The ImageFilter layer created by setting filterQuality will introduce
    // a saveLayer call. This is usually worthwhile when animating the layer,
    // but leaving it in the layer tree before the animation has started or after
    // it has finished significantly hurts performance.
    final bool useFilterQuality;

    switch (tilts.status) {
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        useFilterQuality = false;
        break;
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        useFilterQuality = true;
        break;
    }
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(180 * tilts.value / 180 * math.pi),
      alignment: Alignment.center,
      filterQuality: useFilterQuality ? filterQuality : null,
      child: child,
    );
  }
}

class PivotSwitcher extends StatelessWidget {
  const PivotSwitcher({
    required this.listenable,
    required this.pivot,
    required this.first,
    required this.second,
    super.key,
  });

  final ValueListenable<double> listenable;
  final double pivot;
  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: listenable,
      builder: (context, value, _) {
        return value <= pivot ? first : second;
      },
    );
  }
}
