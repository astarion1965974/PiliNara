import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/custom_height_widget.dart';
import 'package:material_ui/material_ui.dart';

/// The title row and search row move and clip as a single surface.
const double homeTitleBarHeight = 56;
const double homeHeaderHeight = homeTitleBarHeight + Style.topBarHeight;

/// Provides the current top inset occupied by the floating home glass header
/// so each tab's scroll view starts right below the glass and scrolls under it.
class HomeHeaderInsetScope extends InheritedWidget {
  const HomeHeaderInsetScope({
    super.key,
    required this.topInset,
    required super.child,
  });

  final double topInset;

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<HomeHeaderInsetScope>()
          ?.topInset ??
      0.0;

  @override
  bool updateShouldNotify(HomeHeaderInsetScope oldWidget) =>
      topInset != oldWidget.topInset;
}

/// Computes the RefreshIndicator edgeOffset so the settled indicator rests ~8dp
/// below the floating glass bottom edge regardless of global displacement.
double homeRefreshEdgeOffset(double topInset, double displacement) {
  if (topInset <= 0) return 0.0;
  return (topInset - displacement + 8.0).clamp(0.0, topInset).toDouble();
}

/// Directional hysteresis gate preventing accidental header/bar reveal during downward browsing.
class HeaderRevealGate {
  HeaderRevealGate({
    this.collapseThreshold = 12.0,
    this.revealThresholdAtTop = 24.0,
    this.revealThreshold = 48.0,
  });

  final double collapseThreshold;
  final double revealThresholdAtTop;
  final double revealThreshold;

  double _collapseAccum = 0.0;
  double _revealAccum = 0.0;
  bool _collapseOpen = false;
  bool _revealOpen = false;

  void reset() {
    _collapseAccum = 0.0;
    _revealAccum = 0.0;
    _collapseOpen = false;
    _revealOpen = false;
  }

  /// Filters a vertical scroll [delta] (`> 0` collapses, `< 0` reveals) at [pixels].
  /// Returns the permitted delta (`0.0` while gated).
  double applyScrollDelta(
    double delta, {
    required double pixels,
    bool isOverscroll = false,
  }) {
    if (delta == 0.0) return 0.0;

    if (delta > 0) {
      _revealAccum = 0.0;
      _revealOpen = false;
      if (isOverscroll) return 0.0;
      _collapseAccum += delta;
      if (_collapseOpen) return delta;
      if (_collapseAccum >= collapseThreshold) {
        _collapseOpen = true;
        return delta;
      }
      return 0.0;
    }

    _collapseAccum = 0.0;
    _collapseOpen = false;
    if (isOverscroll) return 0.0;
    _revealAccum += -delta;
    if (_revealOpen) return delta;
    if (_revealAccum >= revealThreshold ||
        (_revealAccum >= revealThresholdAtTop && pixels <= 0.0)) {
      _revealOpen = true;
      return delta;
    }
    return 0.0;
  }
}

/// Finish a partially collapsed header in the direction of the user's drag.
double homeHeaderSnapTarget(double offset, double scrollDirection) {
  if (offset <= 0) return 0;
  if (offset >= homeHeaderHeight) return homeHeaderHeight;
  if (scrollDirection > 0) return homeHeaderHeight;
  if (scrollDirection < 0) return 0;
  return offset >= homeHeaderHeight / 2 ? homeHeaderHeight : 0;
}

/// Animates the header while compensating the scroll position for its height.
class HomeHeaderSnapAnimator {
  HomeHeaderSnapAnimator({
    required TickerProvider vsync,
    required this.readOffset,
    required this.writeOffset,
  }) : _animation = AnimationController(
         vsync: vsync,
         duration: const Duration(milliseconds: 220),
       ) {
    _animation.addListener(_tick);
  }

  final ValueGetter<double> readOffset;
  final ValueChanged<double> writeOffset;
  final AnimationController _animation;
  ScrollPosition? _position;
  double _start = 0;
  double _end = 0;

  void settle({required ScrollPosition position, required double target}) {
    _position = position;
    _start = readOffset().clamp(0.0, homeHeaderHeight).toDouble();
    _end = target.clamp(0.0, homeHeaderHeight).toDouble();
    if (_start != _end) _animation.forward(from: 0);
  }

  void _tick() {
    final position = _position;
    if (position == null || !position.hasPixels) return;
    final progress = Curves.easeOutCubic.transform(_animation.value);
    final next = _start + (_end - _start) * progress;
    final delta = readOffset() - next;
    if (position.hasContentDimensions) {
      final corrected = (position.pixels + delta)
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();
      position.correctBy(corrected - position.pixels);
    }
    writeOffset(next);
  }

  void stop() => _animation.stop();

  void dispose() => _animation.dispose();
}

class HomeHeaderClip extends StatelessWidget {
  const HomeHeaderClip({super.key, required this.offset, required this.child});

  final double offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final hidden = offset.clamp(0.0, homeHeaderHeight).toDouble();
    return ClipRect(
      child: CustomHeightWidget(
        height: homeHeaderHeight - hidden,
        offset: Offset(0, -hidden),
        child: SizedBox(
          height: homeHeaderHeight,
          child: IgnorePointer(
            ignoring: hidden >= homeHeaderHeight,
            child: ExcludeSemantics(
              excluding: hidden >= homeHeaderHeight,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
