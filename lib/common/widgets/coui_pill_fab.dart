import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart';

/// Capsule-shaped COUI pill action button with contour border and press scale feedback.
class CouiPillFab extends StatefulWidget {
  const CouiPillFab({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.margin = EdgeInsets.zero,
    this.height = 34,
    this.horizontalPadding = 12,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final EdgeInsetsGeometry margin;
  final double height;
  final double horizontalPadding;

  @override
  State<CouiPillFab> createState() => _CouiPillFabState();
}

class _CouiPillFabState extends State<CouiPillFab> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final coui = CouiThemeData.of(context);
    final accent = coui.accent;
    return Padding(
      padding: widget.margin,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: coui.pillColor,
            borderRadius: Coui.controlRadius,
            border: Border.all(color: coui.pillBorder),
            boxShadow: [
              BoxShadow(
                color: coui.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: Coui.controlRadius,
            child: InkWell(
              borderRadius: Coui.controlRadius,
              onTap: widget.onPressed,
              onHighlightChanged: (v) => setState(() => _pressed = v),
              child: SizedBox(
                height: widget.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.horizontalPadding,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 16, color: accent),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
