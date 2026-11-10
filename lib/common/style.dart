import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart'
    show BorderRadius, Radius, BoxConstraints, ButtonStyle, VisualDensity;

abstract final class Style {
  static const cardSpace = 8.0;
  static const safeSpace = 12.0;
  static const mdRadius = BorderRadius.all(imgRadius);
  static const imgRadius = Radius.circular(Coui.image);
  static const borderRadius6 = Coui.badgeRadius;
  static const aspectRatio = 16 / 10;
  static const aspectRatio16x9 = 16 / 9;
  static const aspectRatio3x4 = 3 / 4;
  static const imgMaxRatio = 2.6;
  static const bottomSheetRadius = Coui.sheetRadius;
  static const dialogFixedConstraints = BoxConstraints.tightFor(width: 420);
  static const topBarHeight = 52.0;
  static const buttonStyle = ButtonStyle(
    visualDensity: VisualDensity(horizontal: -2, vertical: -1.25),
    tapTargetSize: .shrinkWrap,
  );
  static const placeHolder = '\uFFFC';
}
