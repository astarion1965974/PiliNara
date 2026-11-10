import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_header.dart';
import 'package:PiliPlus/pages/video/widgets/detail_chrome.dart';
import 'package:material_ui/material_ui.dart';

class LiveSliverPinnedHeader extends SliverPinnedHeader {
  const LiveSliverPinnedHeader({
    super.key,
    required super.child,
    super.backgroundColor,
    required this.areaHeight,
    required this.callback,
  });

  final double areaHeight;
  final ValueChanged<double> callback;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final color = backgroundColor;
    final fill = color == null || color == scheme.surface
        ? VideoDetailChrome.background(scheme)
        : color;
    return RenderLiveSliverPinnedHeader(
      backgroundColor: fill,
      areaHeight: areaHeight,
      callback: callback,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderLiveSliverPinnedHeader renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..areaHeight = areaHeight
      ..callback = callback;
  }
}

class RenderLiveSliverPinnedHeader extends RenderSliverPinnedHeader {
  RenderLiveSliverPinnedHeader({
    required super.backgroundColor,
    required this._areaHeight,
    required this.callback,
  });

  double _areaHeight;
  set areaHeight(double value) {
    if (_areaHeight == value) return;
    _areaHeight = value;
    markNeedsLayout();
  }

  ValueChanged<double> callback;

  @override
  void performLayout() {
    super.performLayout();
    final double childExtent = child!.size.height;
    final offset = childExtent - _areaHeight;
    geometry = geometry!.copyWith(
      paintOrigin: -math.min(constraints.scrollOffset, offset),
    );
    callback(offset);
  }
}
