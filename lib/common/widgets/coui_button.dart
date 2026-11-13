import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart';

enum CouiButtonVariant { primary, tonal, ghost }

/// COUI button skeleton with three variants, large continuous corners, and scale feedback.
class CouiButton extends StatefulWidget {
  const CouiButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.variant = CouiButtonVariant.primary,
    this.height = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.expanded = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final CouiButtonVariant variant;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool expanded;

  @override
  State<CouiButton> createState() => _CouiButtonState();
}

class _CouiButtonState extends State<CouiButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final coui = CouiThemeData.of(context);
    final enabled = widget.onPressed != null;

    final Color bg;
    final Color fg;
    final Color border;
    final List<BoxShadow>? shadows;

    switch (widget.variant) {
      case CouiButtonVariant.primary:
        bg = coui.accent;
        fg = scheme.onPrimary;
        border = Colors.transparent;
        shadows = enabled
            ? [
                BoxShadow(
                  color: coui.accent.withValues(alpha: 0.24),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null;
      case CouiButtonVariant.tonal:
        bg = coui.pillColor;
        fg = coui.accent;
        border = coui.pillBorder;
        shadows = null;
      case CouiButtonVariant.ghost:
        bg = Colors.transparent;
        fg = scheme.onSurface;
        border = coui.subtleBorderColor;
        shadows = null;
    }

    final content = AnimatedOpacity(
      opacity: enabled ? (_pressed ? 0.85 : 1.0) : 0.45,
      duration: CouiMotion.pressDuration,
      curve: CouiMotion.pressCurve,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: CouiMotion.pressDuration,
        curve: CouiMotion.pressCurve,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: Coui.controlRadius,
            border: border == Colors.transparent
                ? null
                : Border.all(color: border, width: 0.75),
            boxShadow: shadows,
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: Coui.controlRadius,
            child: InkWell(
              borderRadius: Coui.controlRadius,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: widget.onPressed,
              onHighlightChanged: enabled
                  ? (v) => setState(() => _pressed = v)
                  : null,
              child: SizedBox(
                height: widget.height,
                width: widget.expanded ? double.infinity : null,
                child: Padding(
                  padding: widget.padding,
                  child: Row(
                    mainAxisSize:
                        widget.expanded ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 18, color: fg),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: fg,
                          fontSize: 14,
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

    return content;
  }
}
