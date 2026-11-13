import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoThemeData;
import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:material_ui/material_ui.dart';

abstract final class ThemeUtils {
  static late ThemeData lightTheme;

  static late ThemeData darkTheme;

  static late ThemeMode themeMode;

  static ThemeData get theme {
    if (themeMode == .dark ||
        (themeMode == .system &&
            PlatformDispatcher.instance.platformBrightness == .dark)) {
      return darkTheme;
    }
    return lightTheme;
  }

  static bool get isDarkMode => theme.isDark;

  static String themeUrl(bool isDark) =>
      'native.theme=${isDark ? 2 : 1}&night=${isDark ? 1 : 0}';

  static ThemeData getThemeData({
    required ColorScheme colorScheme,
    required bool isDynamic,
    bool isDark = false,
  }) {
    final fontWeight = Pref.appFontWeight;
    final fontFamily = Pref.appFont;

    TextTheme? textTheme;
    if (fontWeight != .normal) {
      final textStyle = TextStyle(fontWeight: fontWeight);
      textTheme = TextTheme(
        displayLarge: textStyle,
        displayMedium: textStyle,
        displaySmall: textStyle,
        headlineLarge: textStyle,
        headlineMedium: textStyle,
        headlineSmall: textStyle,
        titleLarge: textStyle,
        titleMedium: textStyle,
        titleSmall: textStyle,
        bodyLarge: textStyle,
        bodyMedium: textStyle,
        bodySmall: textStyle,
        labelLarge: textStyle,
        labelMedium: textStyle,
        labelSmall: textStyle,
      );
    }

    const buttonShape = WidgetStatePropertyAll<OutlinedBorder>(
      Coui.controlShape,
    );
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        toolbarHeight: 52,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: fontWeight == FontWeight.normal
              ? FontWeight.w600
              : fontWeight,
          fontFamily: fontFamily,
          color: colorScheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        surfaceTintColor: isDark ? colorScheme.surfaceContainerHighest : null,
        indicatorShape: const StadiumBorder(),
        height: 64,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        indicatorShape: StadiumBorder(),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
        shape: StadiumBorder(),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(shape: WidgetStatePropertyAll(CircleBorder())),
      ),
      snackBarTheme: SnackBarThemeData(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: Coui.controlRadius),
        actionTextColor: colorScheme.primary,
        closeIconColor: colorScheme.secondary,
        backgroundColor: colorScheme.secondaryContainer,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          color: colorScheme.onSecondaryContainer,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 3,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        shape: Coui.cardShape,
        menuPadding: const EdgeInsets.symmetric(vertical: 4),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14,
            letterSpacing: 0.1,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: Coui.controlRadius),
        controlAffinity: .leading,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        surfaceTintColor: isDark ? colorScheme.onSurfaceVariant : null,
        color: Coui.cardColor(colorScheme),
        shape: Coui.cardShape,
      ),
      progressIndicatorTheme: isDark
          ? ProgressIndicatorThemeData(
              // ignore: deprecated_member_use
              year2023: false,
              refreshBackgroundColor: colorScheme.onInverseSurface,
            )
          // ignore: deprecated_member_use
          : const ProgressIndicatorThemeData(year2023: false),
      dialogTheme: DialogThemeData(
        shape: Coui.dialogShape,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          color: colorScheme.onSurface,
        ),
        backgroundColor: colorScheme.surface,
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: Style.bottomSheetRadius,
        ),
      ),
      // ignore: deprecated_member_use
      sliderTheme: const SliderThemeData(year2023: false),
      tooltipTheme: TooltipThemeData(
        textStyle: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
        ),
        decoration: const BoxDecoration(
          color: Color(0xE6616161), // Colors.grey[700]!.withValues(alpha: 0.9)
          borderRadius: Coui.controlRadius,
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        selectionHandleColor: colorScheme.primary,
      ),
      switchTheme: const SwitchThemeData(
        padding: .zero,
        materialTapTargetSize: .shrinkWrap,
        thumbIcon: WidgetStatePropertyAll<Icon?>(null),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.08),
        space: 12,
        thickness: 0.5,
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        shape: Border(),
        collapsedShape: Border(),
      ),
      filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          shape: buttonShape,
        ),
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(shape: buttonShape),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(shape: buttonShape),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: Coui.controlRadius),
        enabledBorder: OutlineInputBorder(borderRadius: Coui.controlRadius),
        focusedBorder: OutlineInputBorder(borderRadius: Coui.controlRadius),
      ),
      chipTheme: const ChipThemeData(shape: Coui.controlShape),
      menuTheme: const MenuThemeData(
        style: MenuStyle(shape: WidgetStatePropertyAll(Coui.cardShape)),
      ),
      tabBarTheme: const TabBarThemeData(
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: Pref.enablePredictiveBack
              ? const PredictiveBackPageTransitionsBuilder()
              : const CupertinoPageTransitionsBuilder(),
        },
      ),
      extensions: <ThemeExtension<dynamic>>[
        CouiThemeData.fromScheme(colorScheme),
      ],
    );
    if (isDark && Pref.isPureBlackTheme) {
      return darkenTheme(theme);
    }
    return theme;
  }

  static ThemeData darkenTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final color = colorScheme.surfaceContainerHighest.darken(0.7);
    final darkScheme = colorScheme.copyWith(
      primary: colorScheme.primary.darken(0.1),
      onPrimary: colorScheme.onPrimary.darken(0.1),
      primaryContainer: colorScheme.primaryContainer.darken(0.1),
      onPrimaryContainer: colorScheme.onPrimaryContainer.darken(0.1),
      inversePrimary: colorScheme.inversePrimary.darken(0.1),
      secondary: colorScheme.secondary.darken(0.05),
      onSecondary: colorScheme.onSecondary.darken(0.05),
      secondaryContainer: colorScheme.secondaryContainer.darken(0.05),
      onSecondaryContainer: colorScheme.onSecondaryContainer.darken(0.05),
      error: colorScheme.error.darken(0.05),
      surface: Colors.black,
      onSurface: colorScheme.onSurface.darken(0.15),
      surfaceTint: colorScheme.surfaceTint.darken(),
      inverseSurface: colorScheme.inverseSurface.darken(),
      onInverseSurface: colorScheme.onInverseSurface.darken(),
      surfaceContainer: colorScheme.surfaceContainer.darken(),
      surfaceContainerHigh: colorScheme.surfaceContainerHigh.darken(),
      surfaceContainerHighest: colorScheme.surfaceContainerHighest.darken(0.4),
    );
    return theme.copyWith(
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: theme.appBarTheme.copyWith(backgroundColor: Colors.black),
      cardTheme: theme.cardTheme.copyWith(
        color: colorScheme.surfaceContainer.darken(0.75),
      ),
      dialogTheme: theme.dialogTheme.copyWith(backgroundColor: color),
      bottomSheetTheme: theme.bottomSheetTheme.copyWith(backgroundColor: color),
      bottomNavigationBarTheme: theme.bottomNavigationBarTheme.copyWith(
        backgroundColor: color,
      ),
      navigationBarTheme: theme.navigationBarTheme.copyWith(
        backgroundColor: color,
      ),
      navigationRailTheme: theme.navigationRailTheme.copyWith(
        backgroundColor: Colors.black,
      ),
      popupMenuTheme: theme.popupMenuTheme.copyWith(color: color),
      colorScheme: darkScheme,
      extensions: <ThemeExtension<dynamic>>[
        ...theme.extensions.values.where((e) => e is! CouiThemeData),
        CouiThemeData.fromScheme(darkScheme, isPureBlack: true),
      ],
    );
  }
}
