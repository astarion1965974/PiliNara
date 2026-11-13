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
      scheme.brightness == Brightness.dark
      ? scheme.surfaceContainerHigh.withValues(alpha: 0.90)
      : Colors.white.withValues(alpha: 0.92);

  static Color rimColor(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.11)
      : Colors.white.withValues(alpha: 0.85);

  static Color subtleBorderColor(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.05);

  static BoxDecoration cardDecoration(
    ColorScheme scheme, {
    BorderRadiusGeometry borderRadius = cardRadius,
  }) {
    final dark = scheme.brightness == Brightness.dark;
    return BoxDecoration(
      color: cardColor(scheme),
      borderRadius: borderRadius,
      border: Border.all(
        color: subtleBorderColor(scheme),
        width: 0.75,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: dark ? 0.18 : 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
