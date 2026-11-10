import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/custom_height_widget.dart';
import 'package:material_ui/material_ui.dart';

/// The title row and search row move and clip as a single surface.
const double homeTitleBarHeight = 56;
const double homeHeaderHeight = homeTitleBarHeight + Style.topBarHeight;

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
