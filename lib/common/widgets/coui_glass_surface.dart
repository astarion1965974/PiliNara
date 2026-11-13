import 'dart:ui' show ImageFilter;

import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart';

enum CouiGlassTier { chrome, sheet, floating }

/// Standardized COUI glass surface handling ClipRRect -> BackdropFilter -> fill/rim order.
/// Only use on fixed chrome (top bars, sheets, floating capsules) backed by app surfaces.
class CouiGlassSurface extends StatelessWidget {
  const CouiGlassSurface({
    super.key,
    required this.tier,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.topBorderOnly = false,
    this.useBlur = true,
  });

  final CouiGlassTier tier;
  final Widget child;
  final BorderRadius borderRadius;
  final bool topBorderOnly;
  final bool useBlur;

  @override
  Widget build(BuildContext context) {
    final coui = CouiThemeData.of(context);
    final recipe = switch (tier) {
      CouiGlassTier.chrome => coui.glassChrome,
      CouiGlassTier.sheet => coui.glassSheet,
      CouiGlassTier.floating => coui.glassFloating,
    };

    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: recipe.fillColor,
        borderRadius: borderRadius,
        border: topBorderOnly
            ? Border(top: BorderSide(color: recipe.highlightColor, width: 0.75))
            : Border.all(color: recipe.borderColor, width: 0.75),
      ),
      child: child,
    );

    if (useBlur && recipe.blurSigma > 0) {
      surface = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: recipe.blurSigma,
            sigmaY: recipe.blurSigma,
          ),
          child: surface,
        ),
      );
    } else if (borderRadius != BorderRadius.zero) {
      surface = ClipRRect(borderRadius: borderRadius, child: surface);
    }

    if (recipe.shadowBlur > 0) {
      surface = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: recipe.shadowColor,
              blurRadius: recipe.shadowBlur,
              offset: recipe.shadowOffset,
            ),
          ],
        ),
        child: surface,
      );
    }

    return surface;
  }
}
