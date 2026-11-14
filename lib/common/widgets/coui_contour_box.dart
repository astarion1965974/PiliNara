import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart';

enum CouiContourStyle { menu, dialog, button }

/// Universal COUI contour rim painter approximating CouiContour.kt's directional
/// white-light rim (bright top-left highlight fading along edges).
class CouiContourBox extends StatelessWidget {
  const CouiContourBox({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.style = CouiContourStyle.menu,
    this.topBorderOnly = false,
    this.showBorder = true,
    this.topColor,
    this.bottomColor,
    this.strokeWidth = Coui.contourWidth,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final CouiContourStyle style;
  final bool topBorderOnly;
  final bool showBorder;
  final Color? topColor;
  final Color? bottomColor;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    if (!showBorder) return child;
    final coui = CouiThemeData.of(context);
    final effectiveTop = topColor ??
        switch (style) {
          CouiContourStyle.menu => coui.rimColor,
          CouiContourStyle.dialog => coui.rimColor,
          CouiContourStyle.button => coui.rimColor.withValues(
              alpha: coui.rimColor.a * 0.75,
            ),
        };
    final effectiveBottom = bottomColor ?? coui.subtleBorderColor;

    return CustomPaint(
      foregroundPainter: CouiContourPainter(
        borderRadius: borderRadius,
        topColor: effectiveTop,
        bottomColor: effectiveBottom,
        topBorderOnly: topBorderOnly,
        strokeWidth: strokeWidth,
      ),
      child: child,
    );
  }
}

class CouiContourPainter extends CustomPainter {
  const CouiContourPainter({
    required this.borderRadius,
    required this.topColor,
    required this.bottomColor,
    this.topBorderOnly = false,
    this.strokeWidth = Coui.contourWidth,
  });

  final BorderRadius borderRadius;
  final Color topColor;
  final Color bottomColor;
  final bool topBorderOnly;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [topColor, bottomColor],
      ).createShader(rect);

    if (topBorderOnly) {
      final y = strokeWidth * 0.5;
      final tl = borderRadius.topLeft.x;
      final tr = borderRadius.topRight.x;
      final path = Path();
      if (tl > 0 || tr > 0) {
        final rrect = borderRadius.toRRect(rect.deflate(strokeWidth * 0.5));
        path
          ..moveTo(rrect.left, rrect.top + rrect.tlRadiusY)
          ..arcToPoint(
            Offset(rrect.left + rrect.tlRadiusX, rrect.top),
            radius: Radius.elliptical(rrect.tlRadiusX, rrect.tlRadiusY),
          )
          ..lineTo(rrect.right - rrect.trRadiusX, rrect.top)
          ..arcToPoint(
            Offset(rrect.right, rrect.top + rrect.trRadiusY),
            radius: Radius.elliptical(rrect.trRadiusX, rrect.trRadiusY),
          );
      } else {
        path
          ..moveTo(0, y)
          ..lineTo(size.width, y);
      }
      canvas.drawPath(path, paint);
      return;
    }

    final rrect = borderRadius.toRRect(rect.deflate(strokeWidth * 0.5));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CouiContourPainter oldDelegate) =>
      borderRadius != oldDelegate.borderRadius ||
      topColor != oldDelegate.topColor ||
      bottomColor != oldDelegate.bottomColor ||
      topBorderOnly != oldDelegate.topBorderOnly ||
      strokeWidth != oldDelegate.strokeWidth;
}
