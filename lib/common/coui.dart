import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

/// Shared COUI component sizes, continuous-curvature shapes, and material tokens.
abstract final class Coui {
  static const card = 22.0;
  static const control = 18.0;
  static const image = 16.0;
  static const badge = 8.0;
  static const sheet = 28.0;

  /// Physical line width from CouiContour.kt (`2.5f * density`), expressed as
  /// logical dp at typical 2.5-3.0x mobile density (~1.0dp).
  static const contourWidth = 1.0;

  static const cardRadius = BorderRadius.all(Radius.circular(card));
  static const controlRadius = BorderRadius.all(Radius.circular(control));
  static const inputRadius = controlRadius;
  static const imageRadius = BorderRadius.all(Radius.circular(image));
  static const badgeRadius = BorderRadius.all(Radius.circular(badge));
  static const sheetRadius = BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
  static const coverTopRadius = BorderRadius.vertical(
    top: Radius.circular(card),
  );

  static const controlShape = RoundedSuperellipseBorder(
    borderRadius: controlRadius,
  );
  static const cardShape = RoundedSuperellipseBorder(borderRadius: cardRadius);
  static const dialogRadius = BorderRadius.all(Radius.circular(sheet));
  static const dialogShape = RoundedSuperellipseBorder(
    borderRadius: dialogRadius,
  );

  static Color cardColor(ColorScheme scheme) =>
      CouiThemeData.fromScheme(scheme).cardColor;

  static Color rimColor(ColorScheme scheme) =>
      CouiThemeData.fromScheme(scheme).rimColor;

  static Color subtleBorderColor(ColorScheme scheme) =>
      CouiThemeData.fromScheme(scheme).subtleBorderColor;

  static BoxDecoration cardDecoration(
    ColorScheme scheme, {
    BorderRadiusGeometry borderRadius = cardRadius,
    CouiThemeData? coui,
  }) {
    final resolved = coui ?? CouiThemeData.fromScheme(scheme);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [resolved.cardColor, resolved.cardBottomColor],
      ),
      borderRadius: borderRadius,
      border: Border.all(
        color: resolved.subtleBorderColor,
        width: 0.75,
      ),
      boxShadow: [
        BoxShadow(
          color: resolved.shadowColor,
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

/// Shared COUI motion curves, durations, and spring physics from CouiSpring / CouiPressMotion / CouiSwitchMotion.
abstract final class CouiMotion {
  static const Curve pageTransitionCurve = Cubic(0.22, 1.0, 0.36, 1.0);
  static const Duration pageTransitionDuration = Duration(milliseconds: 360);

  static const Curve sheetCurve = Curves.easeOutQuint;
  static const Duration sheetDuration = Duration(milliseconds: 340);
  static const Duration sheetReverseDuration = Duration(milliseconds: 260);

  static const Curve dialogCurve = Curves.easeOutQuint;
  static const Duration dialogDuration = Duration(milliseconds: 280);

  static const Curve pressCurve = Curves.easeOutCubic;
  static const Duration pressDuration = Duration(milliseconds: 140);

  static const Curve stateCurve = Curves.easeOutCubic;
  static const Duration stateDuration = Duration(milliseconds: 220);

  static const Curve pressAreaInterpolator = Cubic(0, 0, 0, 1);

  static const Tolerance springTolerance = Tolerance(
    distance: 0.0005,
    velocity: 0.005,
  );

  /// Converts COUI (response, bounce) to Flutter [SpringDescription].
  /// dampingRatio = 1 - bounce; stiffness = (2*pi / response)^2.
  static SpringDescription spring({
    required double response,
    double bounce = 0.0,
  }) {
    final omega = 2.0 * math.pi / response;
    return SpringDescription.withDampingRatio(
      mass: 1.0,
      stiffness: omega * omega,
      ratio: (1.0 - bounce).clamp(0.05, 2.0),
    );
  }

  static final SpringDescription pressDefaultSpring = spring(
    response: 0.25,
    bounce: 0.0,
  );
  static final SpringDescription pressCandySpring = spring(
    response: 0.30,
    bounce: 0.0,
  );
  static final SpringDescription releaseDefaultSpring = spring(
    response: 0.50,
    bounce: 0.60,
  );
  static final SpringDescription releaseCandySpring = spring(
    response: 0.50,
    bounce: 0.50,
  );

  static final SpringDescription switchToggleSpring = spring(
    response: 0.40,
    bounce: 0.30,
  );
  static final SpringDescription switchDragSpring = spring(
    response: 0.30,
    bounce: 0.0,
  );
  static final SpringDescription switchAttachSpring = spring(
    response: 0.40,
    bounce: 0.20,
  );
}

/// Official COUI glass material recipe with gradient endpoints for dual-layer material feel.
class CouiGlassRecipe {
  const CouiGlassRecipe({
    required this.fillColor,
    required this.fillEndColor,
    required this.borderColor,
    required this.highlightColor,
    required this.blurSigma,
    required this.shadowColor,
    required this.shadowBlur,
    required this.shadowOffset,
  });

  final Color fillColor;
  final Color fillEndColor;
  final Color borderColor;
  final Color highlightColor;
  final double blurSigma;
  final Color shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;

  static CouiGlassRecipe lerp(
    CouiGlassRecipe a,
    CouiGlassRecipe b,
    double t,
  ) {
    return CouiGlassRecipe(
      fillColor: Color.lerp(a.fillColor, b.fillColor, t)!,
      fillEndColor: Color.lerp(a.fillEndColor, b.fillEndColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t)!,
      blurSigma: lerpDouble(a.blurSigma, b.blurSigma, t)!,
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t)!,
      shadowBlur: lerpDouble(a.shadowBlur, b.shadowBlur, t)!,
      shadowOffset: Offset.lerp(a.shadowOffset, b.shadowOffset, t)!,
    );
  }
}

/// Dynamic COUI visual tokens calibrated against COUI-Kit alpha11 presets while preserving dynamic accent.
class CouiThemeData extends ThemeExtension<CouiThemeData> {
  const CouiThemeData({
    required this.cardColor,
    required this.cardBottomColor,
    required this.rimColor,
    required this.subtleBorderColor,
    required this.shadowColor,
    required this.dividerColor,
    required this.surfaceBackground,
    required this.surfaceGradientMid,
    required this.surfaceGradientEnd,
    required this.accent,
    required this.pillColor,
    required this.pillBorder,
    required this.inactivePillColor,
    required this.inactivePillBorder,
    required this.navTopColor,
    required this.navBottomColor,
    required this.navHighlightColor,
    required this.navRimBottomColor,
    required this.navForeground,
    required this.navSelectedPillColor,
    required this.navSelectedBorderColor,
    required this.switchTrackOffColor,
    required this.switchTrackOnColor,
    required this.switchThumbColor,
    required this.switchDisabledTrackOffColor,
    required this.switchDisabledTrackOnColor,
    required this.switchDisabledThumbColor,
    required this.switchFocusOutlineColor,
    required this.switchTrackRimActiveColor,
    required this.switchTrackRimInactiveColor,
    required this.liveOverlaySurface,
    required this.liveOverlayBorder,
    required this.liveOverlayPill,
    required this.inputFillColor,
    required this.inputBorderColor,
    required this.glassChrome,
    required this.glassSheet,
    required this.glassFloating,
  });

  final Color cardColor;
  final Color cardBottomColor;
  final Color rimColor;
  final Color subtleBorderColor;
  final Color shadowColor;
  final Color dividerColor;

  final Color surfaceBackground;
  final Color surfaceGradientMid;
  final Color surfaceGradientEnd;

  final Color accent;
  final Color pillColor;
  final Color pillBorder;
  final Color inactivePillColor;
  final Color inactivePillBorder;

  final Color navTopColor;
  final Color navBottomColor;
  final Color navHighlightColor;
  final Color navRimBottomColor;
  final Color navForeground;
  final Color navSelectedPillColor;
  final Color navSelectedBorderColor;

  final Color switchTrackOffColor;
  final Color switchTrackOnColor;
  final Color switchThumbColor;
  final Color switchDisabledTrackOffColor;
  final Color switchDisabledTrackOnColor;
  final Color switchDisabledThumbColor;
  final Color switchFocusOutlineColor;
  final Color switchTrackRimActiveColor;
  final Color switchTrackRimInactiveColor;

  final Color liveOverlaySurface;
  final Color liveOverlayBorder;
  final Color liveOverlayPill;

  final Color inputFillColor;
  final Color inputBorderColor;

  final CouiGlassRecipe glassChrome;
  final CouiGlassRecipe glassSheet;
  final CouiGlassRecipe glassFloating;

  factory CouiThemeData.fromScheme(
    ColorScheme scheme, {
    bool isPureBlack = false,
  }) {
    final dark = scheme.brightness == Brightness.dark;
    final pureBlack = dark && (isPureBlack || scheme.surface == Colors.black);

    // Calibrated against CouiPresets.Light (white card on 0xFFF0F1F2) & Dark (0x1AFFFFFF card on 0xFF1E1E1E / Black)
    final cardColor = pureBlack
        ? const Color(0x1AFFFFFF)
        : dark
        ? Color.alphaBlend(const Color(0x1AFFFFFF), const Color(0xFF1E1E1E))
        : Colors.white;

    final cardBottomColor = pureBlack
        ? const Color(0x12FFFFFF)
        : dark
        ? Color.alphaBlend(const Color(0x12FFFFFF), const Color(0xFF1E1E1E))
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.012),
            const Color(0xFFFAFAFB),
          );

    final rimColor = dark
        ? Colors.white.withValues(alpha: pureBlack ? 0.12 : 0.16)
        : Colors.white.withValues(alpha: 0.88);

    final subtleBorderColor = dark
        ? Colors.white.withValues(alpha: pureBlack ? 0.10 : 0.09)
        : scheme.onSurface.withValues(alpha: 0.04);

    final shadowColor = Colors.black.withValues(
      alpha: pureBlack ? 0.0 : (dark ? 0.22 : 0.045),
    );

    // Calibrated against CouiPresets outlineVariant (0x1F000000 / 0x33FFFFFF)
    final dividerColor = dark
        ? const Color(0x33FFFFFF).withValues(alpha: pureBlack ? 0.16 : 0.18)
        : const Color(0x1F000000).withValues(alpha: 0.09);

    final surfaceBackground = pureBlack
        ? Colors.black
        : dark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.06),
            const Color(0xFF1E1E1E),
          )
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.045),
            const Color(0xFFF0F1F2),
          );

    final surfaceGradientMid = pureBlack
        ? Colors.black
        : dark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.03),
            const Color(0xFF18181A),
          )
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.015),
            const Color(0xFFF0F1F2),
          );

    final surfaceGradientEnd = pureBlack
        ? Colors.black
        : dark
        ? const Color(0xFF121214)
        : const Color(0xFFF0F1F2);

    final accent = scheme.primary;
    final pillColor = accent.withValues(
      alpha: pureBlack ? 0.22 : (dark ? 0.18 : 0.11),
    );
    final pillBorder = accent.withValues(
      alpha: pureBlack ? 0.30 : (dark ? 0.26 : 0.18),
    );
    final inactivePillColor = scheme.onSurface.withValues(
      alpha: pureBlack ? 0.10 : (dark ? 0.08 : 0.05),
    );
    final inactivePillBorder = scheme.outline.withValues(
      alpha: dark ? 0.16 : 0.08,
    );

    final navTopColor = pureBlack
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.06),
            const Color(0xFF1E1E20),
          ).withValues(alpha: 0.78)
        : dark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.07),
            const Color(0xFF333333),
          ).withValues(alpha: 0.72)
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.03),
            Colors.white,
          ).withValues(alpha: 0.76);

    final navBottomColor = pureBlack
        ? const Color(0xFF0E0E10).withValues(alpha: 0.86)
        : dark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.03),
            const Color(0xFF1E1E1E),
          ).withValues(alpha: 0.82)
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.04),
            const Color(0xFFF0F1F2),
          ).withValues(alpha: 0.68);

    final navHighlightColor = Colors.white.withValues(
      alpha: pureBlack ? 0.22 : (dark ? 0.30 : 0.88),
    );
    final navRimBottomColor = dark
        ? Colors.white.withValues(alpha: 0.08)
        : scheme.onSurface.withValues(alpha: 0.06);

    final glassChrome = CouiGlassRecipe(
      fillColor: surfaceBackground.withValues(
        alpha: pureBlack ? 0.78 : (dark ? 0.68 : 0.68),
      ),
      fillEndColor: surfaceGradientMid.withValues(
        alpha: pureBlack ? 0.64 : (dark ? 0.54 : 0.52),
      ),
      borderColor: dark
          ? subtleBorderColor
          : Colors.white.withValues(alpha: 0.32),
      highlightColor: rimColor,
      blurSigma: 18,
      shadowColor: Colors.black.withValues(alpha: 0.0),
      shadowBlur: 0,
      shadowOffset: Offset.zero,
    );

    final glassSheet = CouiGlassRecipe(
      fillColor: pureBlack
          ? const Color(0xFF18181A).withValues(alpha: 0.88)
          : dark
          ? const Color(0xFF333333).withValues(alpha: 0.82)
          : Colors.white.withValues(alpha: 0.84),
      fillEndColor: pureBlack
          ? const Color(0xFF101012).withValues(alpha: 0.94)
          : dark
          ? const Color(0xFF1E1E1E).withValues(alpha: 0.90)
          : const Color(0xFFF6F7F8).withValues(alpha: 0.90),
      borderColor: subtleBorderColor,
      highlightColor: rimColor,
      blurSigma: 26,
      shadowColor: Colors.black.withValues(
        alpha: pureBlack ? 0.0 : (dark ? 0.28 : 0.10),
      ),
      shadowBlur: 24,
      shadowOffset: const Offset(0, -4),
    );

    final glassFloating = CouiGlassRecipe(
      fillColor: navTopColor,
      fillEndColor: navBottomColor,
      borderColor: navRimBottomColor,
      highlightColor: navHighlightColor,
      blurSigma: 28,
      shadowColor: Colors.black.withValues(alpha: dark ? 0.30 : 0.12),
      shadowBlur: 28,
      shadowOffset: const Offset(0, 10),
    );

    return CouiThemeData(
      cardColor: cardColor,
      cardBottomColor: cardBottomColor,
      rimColor: rimColor,
      subtleBorderColor: subtleBorderColor,
      shadowColor: shadowColor,
      dividerColor: dividerColor,
      surfaceBackground: surfaceBackground,
      surfaceGradientMid: surfaceGradientMid,
      surfaceGradientEnd: surfaceGradientEnd,
      accent: accent,
      pillColor: pillColor,
      pillBorder: pillBorder,
      inactivePillColor: inactivePillColor,
      inactivePillBorder: inactivePillBorder,
      navTopColor: navTopColor,
      navBottomColor: navBottomColor,
      navHighlightColor: navHighlightColor,
      navRimBottomColor: navRimBottomColor,
      navForeground: dark ? const Color(0xE6FFFFFF) : const Color(0xE6000000),
      navSelectedPillColor: accent.withValues(
        alpha: pureBlack ? 0.24 : (dark ? 0.20 : 0.12),
      ),
      navSelectedBorderColor: accent.withValues(
        alpha: pureBlack ? 0.30 : (dark ? 0.24 : 0.16),
      ),
      // Exact CouiSwitchDefaults.colors(accent, dark) table
      switchTrackOffColor: dark
          ? const Color(0x40FFFFFF)
          : const Color(0x29000000),
      switchTrackOnColor: accent,
      switchThumbColor: Colors.white,
      switchDisabledTrackOffColor: dark
          ? const Color(0x26FFFFFF)
          : const Color(0x14000000),
      switchDisabledTrackOnColor: accent.withValues(alpha: 0x4D / 255.0),
      switchDisabledThumbColor: dark
          ? const Color(0x29FFFFFF)
          : const Color(0x8AFFFFFF),
      switchFocusOutlineColor: accent.withValues(alpha: 0x66 / 255.0),
      switchTrackRimActiveColor: Colors.white.withValues(
        alpha: dark ? 0.12 : 0.18,
      ),
      switchTrackRimInactiveColor: Colors.white.withValues(
        alpha: dark ? 0.10 : 0.06,
      ),
      liveOverlaySurface: Color.alphaBlend(
        scheme.primary.withValues(alpha: 0.06),
        const Color(0xff141418),
      ).withValues(alpha: 0.68),
      liveOverlayBorder: Colors.white.withValues(alpha: 0.16),
      liveOverlayPill: Color.alphaBlend(
        scheme.primary.withValues(alpha: 0.14),
        const Color(0xff1e1e24),
      ).withValues(alpha: 0.76),
      inputFillColor: pureBlack
          ? const Color(0xff161618)
          : dark
          ? const Color(0xFF2B2B2E)
          : Color.alphaBlend(
              scheme.primary.withValues(alpha: 0.025),
              Colors.white,
            ),
      inputBorderColor: pureBlack
          ? Colors.white.withValues(alpha: 0.16)
          : subtleBorderColor,
      glassChrome: glassChrome,
      glassSheet: glassSheet,
      glassFloating: glassFloating,
    );
  }

  static CouiThemeData of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<CouiThemeData>() ??
        CouiThemeData.fromScheme(theme.colorScheme);
  }

  @override
  CouiThemeData copyWith({
    Color? cardColor,
    Color? cardBottomColor,
    Color? rimColor,
    Color? subtleBorderColor,
    Color? shadowColor,
    Color? dividerColor,
    Color? surfaceBackground,
    Color? surfaceGradientMid,
    Color? surfaceGradientEnd,
    Color? accent,
    Color? pillColor,
    Color? pillBorder,
    Color? inactivePillColor,
    Color? inactivePillBorder,
    Color? navTopColor,
    Color? navBottomColor,
    Color? navHighlightColor,
    Color? navRimBottomColor,
    Color? navForeground,
    Color? navSelectedPillColor,
    Color? navSelectedBorderColor,
    Color? switchTrackOffColor,
    Color? switchTrackOnColor,
    Color? switchThumbColor,
    Color? switchDisabledTrackOffColor,
    Color? switchDisabledTrackOnColor,
    Color? switchDisabledThumbColor,
    Color? switchFocusOutlineColor,
    Color? switchTrackRimActiveColor,
    Color? switchTrackRimInactiveColor,
    Color? liveOverlaySurface,
    Color? liveOverlayBorder,
    Color? liveOverlayPill,
    Color? inputFillColor,
    Color? inputBorderColor,
    CouiGlassRecipe? glassChrome,
    CouiGlassRecipe? glassSheet,
    CouiGlassRecipe? glassFloating,
  }) {
    return CouiThemeData(
      cardColor: cardColor ?? this.cardColor,
      cardBottomColor: cardBottomColor ?? this.cardBottomColor,
      rimColor: rimColor ?? this.rimColor,
      subtleBorderColor: subtleBorderColor ?? this.subtleBorderColor,
      shadowColor: shadowColor ?? this.shadowColor,
      dividerColor: dividerColor ?? this.dividerColor,
      surfaceBackground: surfaceBackground ?? this.surfaceBackground,
      surfaceGradientMid: surfaceGradientMid ?? this.surfaceGradientMid,
      surfaceGradientEnd: surfaceGradientEnd ?? this.surfaceGradientEnd,
      accent: accent ?? this.accent,
      pillColor: pillColor ?? this.pillColor,
      pillBorder: pillBorder ?? this.pillBorder,
      inactivePillColor: inactivePillColor ?? this.inactivePillColor,
      inactivePillBorder: inactivePillBorder ?? this.inactivePillBorder,
      navTopColor: navTopColor ?? this.navTopColor,
      navBottomColor: navBottomColor ?? this.navBottomColor,
      navHighlightColor: navHighlightColor ?? this.navHighlightColor,
      navRimBottomColor: navRimBottomColor ?? this.navRimBottomColor,
      navForeground: navForeground ?? this.navForeground,
      navSelectedPillColor: navSelectedPillColor ?? this.navSelectedPillColor,
      navSelectedBorderColor:
          navSelectedBorderColor ?? this.navSelectedBorderColor,
      switchTrackOffColor: switchTrackOffColor ?? this.switchTrackOffColor,
      switchTrackOnColor: switchTrackOnColor ?? this.switchTrackOnColor,
      switchThumbColor: switchThumbColor ?? this.switchThumbColor,
      switchDisabledTrackOffColor:
          switchDisabledTrackOffColor ?? this.switchDisabledTrackOffColor,
      switchDisabledTrackOnColor:
          switchDisabledTrackOnColor ?? this.switchDisabledTrackOnColor,
      switchDisabledThumbColor:
          switchDisabledThumbColor ?? this.switchDisabledThumbColor,
      switchFocusOutlineColor:
          switchFocusOutlineColor ?? this.switchFocusOutlineColor,
      switchTrackRimActiveColor:
          switchTrackRimActiveColor ?? this.switchTrackRimActiveColor,
      switchTrackRimInactiveColor:
          switchTrackRimInactiveColor ?? this.switchTrackRimInactiveColor,
      liveOverlaySurface: liveOverlaySurface ?? this.liveOverlaySurface,
      liveOverlayBorder: liveOverlayBorder ?? this.liveOverlayBorder,
      liveOverlayPill: liveOverlayPill ?? this.liveOverlayPill,
      inputFillColor: inputFillColor ?? this.inputFillColor,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      glassChrome: glassChrome ?? this.glassChrome,
      glassSheet: glassSheet ?? this.glassSheet,
      glassFloating: glassFloating ?? this.glassFloating,
    );
  }

  @override
  CouiThemeData lerp(covariant CouiThemeData? other, double t) {
    if (other is! CouiThemeData) return this;
    return CouiThemeData(
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      cardBottomColor: Color.lerp(cardBottomColor, other.cardBottomColor, t)!,
      rimColor: Color.lerp(rimColor, other.rimColor, t)!,
      subtleBorderColor: Color.lerp(
        subtleBorderColor,
        other.subtleBorderColor,
        t,
      )!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      surfaceBackground: Color.lerp(
        surfaceBackground,
        other.surfaceBackground,
        t,
      )!,
      surfaceGradientMid: Color.lerp(
        surfaceGradientMid,
        other.surfaceGradientMid,
        t,
      )!,
      surfaceGradientEnd: Color.lerp(
        surfaceGradientEnd,
        other.surfaceGradientEnd,
        t,
      )!,
      accent: Color.lerp(accent, other.accent, t)!,
      pillColor: Color.lerp(pillColor, other.pillColor, t)!,
      pillBorder: Color.lerp(pillBorder, other.pillBorder, t)!,
      inactivePillColor: Color.lerp(
        inactivePillColor,
        other.inactivePillColor,
        t,
      )!,
      inactivePillBorder: Color.lerp(
        inactivePillBorder,
        other.inactivePillBorder,
        t,
      )!,
      navTopColor: Color.lerp(navTopColor, other.navTopColor, t)!,
      navBottomColor: Color.lerp(navBottomColor, other.navBottomColor, t)!,
      navHighlightColor: Color.lerp(
        navHighlightColor,
        other.navHighlightColor,
        t,
      )!,
      navRimBottomColor: Color.lerp(
        navRimBottomColor,
        other.navRimBottomColor,
        t,
      )!,
      navForeground: Color.lerp(navForeground, other.navForeground, t)!,
      navSelectedPillColor: Color.lerp(
        navSelectedPillColor,
        other.navSelectedPillColor,
        t,
      )!,
      navSelectedBorderColor: Color.lerp(
        navSelectedBorderColor,
        other.navSelectedBorderColor,
        t,
      )!,
      switchTrackOffColor: Color.lerp(
        switchTrackOffColor,
        other.switchTrackOffColor,
        t,
      )!,
      switchTrackOnColor: Color.lerp(
        switchTrackOnColor,
        other.switchTrackOnColor,
        t,
      )!,
      switchThumbColor: Color.lerp(
        switchThumbColor,
        other.switchThumbColor,
        t,
      )!,
      switchDisabledTrackOffColor: Color.lerp(
        switchDisabledTrackOffColor,
        other.switchDisabledTrackOffColor,
        t,
      )!,
      switchDisabledTrackOnColor: Color.lerp(
        switchDisabledTrackOnColor,
        other.switchDisabledTrackOnColor,
        t,
      )!,
      switchDisabledThumbColor: Color.lerp(
        switchDisabledThumbColor,
        other.switchDisabledThumbColor,
        t,
      )!,
      switchFocusOutlineColor: Color.lerp(
        switchFocusOutlineColor,
        other.switchFocusOutlineColor,
        t,
      )!,
      switchTrackRimActiveColor: Color.lerp(
        switchTrackRimActiveColor,
        other.switchTrackRimActiveColor,
        t,
      )!,
      switchTrackRimInactiveColor: Color.lerp(
        switchTrackRimInactiveColor,
        other.switchTrackRimInactiveColor,
        t,
      )!,
      liveOverlaySurface: Color.lerp(
        liveOverlaySurface,
        other.liveOverlaySurface,
        t,
      )!,
      liveOverlayBorder: Color.lerp(
        liveOverlayBorder,
        other.liveOverlayBorder,
        t,
      )!,
      liveOverlayPill: Color.lerp(
        liveOverlayPill,
        other.liveOverlayPill,
        t,
      )!,
      inputFillColor: Color.lerp(inputFillColor, other.inputFillColor, t)!,
      inputBorderColor: Color.lerp(
        inputBorderColor,
        other.inputBorderColor,
        t,
      )!,
      glassChrome: CouiGlassRecipe.lerp(glassChrome, other.glassChrome, t),
      glassSheet: CouiGlassRecipe.lerp(glassSheet, other.glassSheet, t),
      glassFloating: CouiGlassRecipe.lerp(
        glassFloating,
        other.glassFloating,
        t,
      ),
    );
  }
}
