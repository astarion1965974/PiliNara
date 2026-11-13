import 'package:material_ui/material_ui.dart';

/// Shared COUI component sizes, continuous-curvature shapes, and material tokens.
abstract final class Coui {
  static const card = 22.0;
  static const control = 18.0;
  static const image = 16.0;
  static const badge = 8.0;
  static const sheet = 28.0;

  static const cardRadius = BorderRadius.all(Radius.circular(card));
  static const controlRadius = BorderRadius.all(Radius.circular(control));
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
      color: resolved.cardColor,
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

/// Dynamic COUI visual tokens derived from the active [ColorScheme].
class CouiThemeData extends ThemeExtension<CouiThemeData> {
  const CouiThemeData({
    required this.cardColor,
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
    required this.switchTrackRimActiveColor,
    required this.switchTrackRimInactiveColor,
  });

  final Color cardColor;
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
  final Color switchTrackRimActiveColor;
  final Color switchTrackRimInactiveColor;

  factory CouiThemeData.fromScheme(
    ColorScheme scheme, {
    bool isPureBlack = false,
  }) {
    final dark = scheme.brightness == Brightness.dark;
    final pureBlack = dark && (isPureBlack || scheme.surface == Colors.black);

    final cardColor = pureBlack
        ? Color.alphaBlend(
            scheme.surfaceContainerHigh.withValues(alpha: 0.72),
            Colors.black,
          )
        : dark
        ? scheme.surfaceContainerHigh.withValues(alpha: 0.90)
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.015),
            Colors.white,
          ).withValues(alpha: 0.94);

    final rimColor = dark
        ? Colors.white.withValues(alpha: pureBlack ? 0.08 : 0.11)
        : Colors.white.withValues(alpha: 0.85);

    final subtleBorderColor = dark
        ? Colors.white.withValues(alpha: pureBlack ? 0.10 : 0.08)
        : scheme.onSurface.withValues(alpha: 0.06);

    final shadowColor = Colors.black.withValues(
      alpha: pureBlack ? 0.0 : (dark ? 0.18 : 0.04),
    );

    final dividerColor = scheme.outline.withValues(
      alpha: pureBlack ? 0.16 : 0.12,
    );

    final surfaceBackground = pureBlack
        ? Colors.black
        : dark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.08),
            scheme.surfaceContainerLowest,
          )
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.06),
            scheme.surface,
          );

    final surfaceGradientMid = pureBlack
        ? Colors.black
        : dark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.04),
            scheme.surface,
          )
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.02),
            scheme.surface,
          );

    final surfaceGradientEnd = pureBlack
        ? Colors.black
        : dark
        ? scheme.surface
        : scheme.surfaceContainerLowest;

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
            const Color(0xff1c1c1e),
          ).withValues(alpha: 0.84)
        : dark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.08),
            scheme.surfaceContainerHigh,
          ).withValues(alpha: 0.78)
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.03),
            Colors.white,
          ).withValues(alpha: 0.86);

    final navBottomColor = pureBlack
        ? const Color(0xff0a0a0c).withValues(alpha: 0.90)
        : dark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.04),
            scheme.surfaceContainerLow,
          ).withValues(alpha: 0.88)
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.05),
            scheme.surfaceContainerLow,
          ).withValues(alpha: 0.76);

    final navHighlightColor = Colors.white.withValues(
      alpha: pureBlack ? 0.20 : (dark ? 0.28 : 0.86),
    );
    final navRimBottomColor = scheme.onSurface.withValues(
      alpha: pureBlack ? 0.12 : (dark ? 0.10 : 0.07),
    );

    return CouiThemeData(
      cardColor: cardColor,
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
      navForeground: scheme.onSurface,
      navSelectedPillColor: accent.withValues(
        alpha: pureBlack ? 0.24 : (dark ? 0.20 : 0.12),
      ),
      navSelectedBorderColor: accent.withValues(
        alpha: pureBlack ? 0.30 : (dark ? 0.24 : 0.16),
      ),
      switchTrackOffColor: scheme.onSurface.withValues(
        alpha: pureBlack ? 0.28 : (dark ? 0.24 : 0.16),
      ),
      switchTrackOnColor: accent,
      switchThumbColor: Colors.white,
      switchTrackRimActiveColor: Colors.white.withValues(
        alpha: dark ? 0.12 : 0.18,
      ),
      switchTrackRimInactiveColor: Colors.white.withValues(
        alpha: dark ? 0.10 : 0.06,
      ),
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
    Color? switchTrackRimActiveColor,
    Color? switchTrackRimInactiveColor,
  }) {
    return CouiThemeData(
      cardColor: cardColor ?? this.cardColor,
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
      switchTrackRimActiveColor:
          switchTrackRimActiveColor ?? this.switchTrackRimActiveColor,
      switchTrackRimInactiveColor:
          switchTrackRimInactiveColor ?? this.switchTrackRimInactiveColor,
    );
  }

  @override
  CouiThemeData lerp(covariant CouiThemeData? other, double t) {
    if (other is! CouiThemeData) return this;
    return CouiThemeData(
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
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
    );
  }
}
