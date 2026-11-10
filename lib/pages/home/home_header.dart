import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/custom_height_widget.dart';
import 'package:material_ui/material_ui.dart';

/// The title row and search row move and clip as a single surface.
const double homeTitleBarHeight = 56;
const double homeHeaderHeight = homeTitleBarHeight + Style.topBarHeight;

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
