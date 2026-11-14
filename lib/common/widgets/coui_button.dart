import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/common/widgets/coui_contour_box.dart';
import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

enum CouiButtonVariant { primary, tonal, ghost }

/// COUI button with continuous corners, CouiContourBox rim, and CouiPressMotion spring physics.
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

class _CouiButtonState extends State<CouiButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  bool _pressed = false;
  bool _isCandy = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController.unbounded(
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleHighlightChanged(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);

    if (pressed) {
      final renderObject = context.findRenderObject();
      final size = renderObject is RenderBox && renderObject.hasSize
          ? renderObject.size
          : Size(widget.expanded ? 300 : 120, widget.height);

      const minArea = 20.0 * 20.0;
      const maxArea = 150.0 * 150.0;
      final area = size.width * size.height;
      final areaProgress = ((area - minArea) / (maxArea - minArea)).clamp(
        0.0,
        1.0,
      );
      final areaScale =
          0.85 + 0.12 * CouiMotion.pressAreaInterpolator.transform(areaProgress);

      final aspect = size.height > 0 ? size.width / size.height : 1.0;
      _isCandy = aspect > 2.0;

      final double target;
      if (_isCandy) {
        final aspectProgress = ((aspect - 2.0) / 13.0).clamp(0.0, 1.0);
        final aspectScale =
            0.85 +
            0.15 * CouiMotion.pressAreaInterpolator.transform(aspectProgress);
        target = ((areaScale + aspectScale) * 0.5).clamp(0.4, 1.0);
      } else {
        target = areaScale.clamp(0.4, 1.0);
      }

      final spring = _isCandy
          ? CouiMotion.pressCandySpring
          : CouiMotion.pressDefaultSpring;
      _scaleController.animateWith(
        SpringSimulation(
          spring,
          _scaleController.value,
          target,
          _scaleController.velocity,
          tolerance: CouiMotion.springTolerance,
        ),
      );
    } else {
      final spring = _isCandy
          ? CouiMotion.releaseCandySpring
          : CouiMotion.releaseDefaultSpring;
      _scaleController.animateWith(
        SpringSimulation(
          spring,
          _scaleController.value,
          1.0,
          _scaleController.velocity,
          tolerance: CouiMotion.springTolerance,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final coui = CouiThemeData.of(context);
    final enabled = widget.onPressed != null;

    final Color bg;
    final Color fg;
    final Color? contourTop;
    final Color? contourBottom;
    final List<BoxShadow>? shadows;

    switch (widget.variant) {
      case CouiButtonVariant.primary:
        bg = coui.accent;
        fg = scheme.onPrimary;
        contourTop = null;
        contourBottom = coui.accent.withValues(alpha: 0.18);
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
        contourTop = coui.rimColor.withValues(alpha: coui.rimColor.a * 0.55);
        contourBottom = coui.pillBorder;
        shadows = null;
      case CouiButtonVariant.ghost:
        bg = Colors.transparent;
        fg = scheme.onSurface;
        contourTop = coui.subtleBorderColor;
        contourBottom = coui.subtleBorderColor;
        shadows = null;
    }

    return AnimatedOpacity(
      opacity: enabled ? (_pressed ? 0.88 : 1.0) : 0.45,
      duration: CouiMotion.pressDuration,
      curve: CouiMotion.pressCurve,
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) => Transform.scale(
          scale: _scaleController.value,
          child: child,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: Coui.controlRadius,
            boxShadow: shadows,
          ),
          child: CouiContourBox(
            borderRadius: Coui.controlRadius,
            style: CouiContourStyle.button,
            topColor: contourTop,
            bottomColor: contourBottom,
            child: Material(
              type: MaterialType.transparency,
              borderRadius: Coui.controlRadius,
              child: InkWell(
                borderRadius: Coui.controlRadius,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: widget.onPressed,
                onHighlightChanged: enabled ? _handleHighlightChanged : null,
                child: SizedBox(
                  height: widget.height,
                  width: widget.expanded ? double.infinity : null,
                  child: Padding(
                    padding: widget.padding,
                    child: Row(
                      mainAxisSize: widget.expanded
                          ? MainAxisSize.max
                          : MainAxisSize.min,
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
      ),
    );
  }
}
