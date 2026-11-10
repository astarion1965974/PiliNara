import 'package:material_ui/material_ui.dart';

/// Shared component sizes. Pages should use these instead of local radii.
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

  static const controlShape = RoundedRectangleBorder(
    borderRadius: controlRadius,
  );
  static const cardShape = RoundedRectangleBorder(borderRadius: cardRadius);
  static const dialogRadius = BorderRadius.all(Radius.circular(sheet));
  static const dialogShape = RoundedRectangleBorder(
    borderRadius: dialogRadius,
  );

  static Color cardColor(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
      ? scheme.surfaceContainerHigh.withValues(alpha: 0.92)
      : Colors.white.withValues(alpha: 0.94);
}
