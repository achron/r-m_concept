import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Global scroll behavior that enables dragging with mouse, touch and stylus.
/// Use this with `MaterialApp.scrollBehavior` to allow trackpad/mouse drag on web.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
