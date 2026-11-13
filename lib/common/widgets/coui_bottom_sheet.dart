import 'dart:ui' show ImageFilter;

import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart';

/// COUI-styled frosted bottom sheet container with top contour rim.
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
    final coui = CouiThemeData.of(context);
    final scheme = ColorScheme.of(context);
    return ClipRRect(
      borderRadius: Coui.sheetRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: coui.cardColor,
            borderRadius: Coui.sheetRadius,
            border: Border(
              top: BorderSide(color: coui.rimColor, width: 0.75),
            ),
          ),
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
        ),
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
    builder: (ctx) => CouiBottomSheet(
      showDragHandle: showDragHandle,
      child: builder(ctx),
    ),
  );
}
