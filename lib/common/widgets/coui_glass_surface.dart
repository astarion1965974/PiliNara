import 'dart:ui' show ImageFilter;

import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/common/widgets/coui_contour_box.dart';
import 'package:material_ui/material_ui.dart';

enum CouiGlassTier { chrome, sheet, floating }

/// Standardized COUI glass surface handling ClipRRect -> BackdropFilter -> gradient fill -> CouiContourBox.
/// Only use on fixed chrome (top bars, sheets, floating capsules) backed by app surfaces.
class CouiGlassSurface extends StatelessWidget {
  const CouiGlassSurface({
    super.key,
    required this.tier,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.topBorderOnly = false,
    this.showBorder = true,
    this.useBlur = true,
    this.progressiveBlur = false,
  });

  final CouiGlassTier tier;
  final Widget child;
  final BorderRadius borderRadius;
  final bool topBorderOnly;
  final bool showBorder;
  final bool useBlur;
  final bool progressiveBlur;

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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [recipe.fillColor, recipe.fillEndColor],
        ),
        borderRadius: borderRadius,
      ),
      child: child,
    );

    if (showBorder) {
      surface = CouiContourBox(
        borderRadius: borderRadius,
        style: CouiContourStyle.menu,
        topBorderOnly: topBorderOnly,
        topColor: recipe.highlightColor,
        bottomColor: recipe.borderColor,
        child: surface,
      );
    }

    if (useBlur && recipe.blurSigma > 0) {
      if (tier == CouiGlassTier.chrome && progressiveBlur) {
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
      } else if (tier == CouiGlassTier.chrome) {
        // Two-band progressive blur approximation for non-progressive chrome (e.g. bottom composer).
        surface = ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      flex: 55,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: recipe.blurSigma,
                            sigmaY: recipe.blurSigma,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 45,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: recipe.blurSigma * 0.45,
                            sigmaY: recipe.blurSigma * 0.45,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              surface,
            ],
          ),
        );
      } else {
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
      }
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
