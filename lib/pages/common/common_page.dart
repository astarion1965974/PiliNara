import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/home/home_header.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

abstract class CommonPageState<T extends StatefulWidget> extends State<T> {
  RxDouble? _barOffset;
  RxBool? _showTopBar;
  RxBool? _showBottomBar;
  final _mainController = Get.find<MainController>();
  final HeaderRevealGate _revealGate = HeaderRevealGate();

  bool get needsCorrection => false;

  /// The collapsible top bar can be taller than the default 52dp bar.
  double get barScrollExtent => Style.topBarHeight;

  @override
  void initState() {
    super.initState();
    _barOffset = _mainController.barOffset;
    _showBottomBar = _mainController.showBottomBar;
    try {
      _showTopBar = Get.find<HomeController>().showTopBar;
    } catch (_) {}
  }

  Widget onBuild(Widget child) {
    if (_barOffset != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: onNotificationType2,
        child: child,
      );
    }
    if (_showTopBar != null || _showBottomBar != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: _onNotificationInstant,
        child: child,
      );
    }
    return child;
  }

  bool _onNotificationInstant(ScrollNotification notification) {
    if (!_mainController.useBottomNav) return false;
    final metrics = notification.metrics;
    if (metrics.axis == .horizontal) return false;

    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _revealGate.reset();
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      if (notification.dragDetails == null) return false;
      final delta = notification.scrollDelta ?? 0.0;
      final gated = _revealGate.applyScrollDelta(delta, pixels: metrics.pixels);
      if (gated > 0) {
        _showTopBar?.value = false;
        _showBottomBar?.value = false;
      } else if (gated < 0) {
        _showTopBar?.value = true;
        _showBottomBar?.value = true;
      }
      return false;
    }

    if (notification is OverscrollNotification) {
      _revealGate.applyScrollDelta(
        notification.overscroll,
        pixels: metrics.pixels,
        isOverscroll: true,
      );
      return false;
    }

    return false;
  }

  bool onNotificationType1(UserScrollNotification notification) {
    if (!_mainController.useBottomNav) return false;
    if (notification.metrics.axis == .horizontal) return false;
    switch (notification.direction) {
      case .forward:
        _showTopBar?.value = true;
        _showBottomBar?.value = true;
      case .reverse:
        _showTopBar?.value = false;
        _showBottomBar?.value = false;
      case _:
    }
    return false;
  }

  void _updateOffset(double scrollDelta) {
    _barOffset!.value = clampDouble(
      _barOffset!.value + scrollDelta,
      0.0,
      barScrollExtent,
    );
  }

  bool onNotificationType2(ScrollNotification notification) {
    if (!_mainController.useBottomNav) return false;

    final metrics = notification.metrics;
    if (metrics.axis == .horizontal) return false;

    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _revealGate.reset();
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      if (notification.dragDetails == null) return false;
      final pixel = metrics.pixels;
      final scrollDelta = notification.scrollDelta ?? 0;
      if (pixel < 0.0 && scrollDelta > 0) return false;
      final gatedDelta = _revealGate.applyScrollDelta(
        scrollDelta,
        pixels: pixel,
      );
      if (gatedDelta == 0.0) return false;
      if (needsCorrection) {
        final value = _barOffset!.value;
        final newValue = clampDouble(
          value + gatedDelta,
          0.0,
          barScrollExtent,
        );
        final offset = value - newValue;
        if (offset != 0) {
          _barOffset!.value = newValue;
          if (pixel < 0.0 && gatedDelta < 0.0 && value > 0.0) {
            return false;
          }
          Scrollable.of(notification.context!).position.correctBy(offset);
        }
      } else {
        _updateOffset(gatedDelta);
      }
      return false;
    }

    if (notification is OverscrollNotification) {
      final gatedOverscroll = _revealGate.applyScrollDelta(
        notification.overscroll,
        pixels: metrics.pixels,
        isOverscroll: true,
      );
      if (gatedOverscroll != 0.0) {
        _updateOffset(gatedOverscroll);
      }
      return false;
    }

    return false;
  }

  @override
  void dispose() {
    _barOffset = null;
    _showTopBar = null;
    _showBottomBar = null;
    super.dispose();
  }
}
