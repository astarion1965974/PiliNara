import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/common/widgets/coui_glass_surface.dart';
import 'package:material_ui/material_ui.dart';

/// COUI-styled frosted bottom sheet container backed by [CouiGlassTier.sheet].
class CouiBottomSheet extends StatelessWidget {
  const CouiBottomSheet({
    super.key,
    required this.child,
    this.showDragHandle = false,
  });

  final Widget child;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    return CouiGlassSurface(
      tier: CouiGlassTier.sheet,
      borderRadius: Coui.sheetRadius,
      topBorderOnly: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const SizedBox(width: 36, height: 4),
              ),
            ),
          Flexible(child: child),
        ],
      ),
    );
  }
}

/// Drops in for [showModalBottomSheet] while preserving return values and barrier/dismiss behavior.
Future<T?> showCouiBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useSafeArea = true,
  bool isScrollControlled = true,
  bool showDragHandle = false,
  bool isDismissible = true,
  bool enableDrag = true,
  BoxConstraints? constraints,
  Color? barrierColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: useSafeArea,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    constraints: constraints,
    barrierColor: barrierColor,
    backgroundColor: Colors.transparent,
    elevation: 0,
    clipBehavior: Clip.none,
    sheetAnimationStyle: const AnimationStyle(
      duration: CouiMotion.sheetDuration,
      reverseDuration: CouiMotion.sheetReverseDuration,
      curve: CouiMotion.sheetCurve,
    ),
    builder: (ctx) => CouiBottomSheet(
      showDragHandle: showDragHandle,
      child: builder(ctx),
    ),
  );
}
