import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart';

/// Shared dynamic colors, horizontal inset, and pill styles for the portrait detail page and its floating bars.
class VideoDetailChrome {
  /// Unified horizontal inset for portrait detail page sections (tab bar, intro card, related videos, reply panel).
  static const double horizontalInset = 12.0;

  static Color background(ColorScheme scheme) =>
      CouiThemeData.fromScheme(scheme).surfaceBackground;

  static Color accent(ColorScheme scheme) =>
      CouiThemeData.fromScheme(scheme).accent;

  static Color pill(ColorScheme scheme) =>
      CouiThemeData.fromScheme(scheme).pillColor;

  static Color pillBorder(ColorScheme scheme, {bool active = true}) {
    final coui = CouiThemeData.fromScheme(scheme);
    return active ? coui.pillBorder : coui.inactivePillBorder;
  }

  static Color inactivePill(ColorScheme scheme) =>
      CouiThemeData.fromScheme(scheme).inactivePillColor;

  static BoxDecoration pillDecoration(
    ColorScheme scheme, {
    bool active = true,
    CouiThemeData? coui,
  }) {
    final resolved = coui ?? CouiThemeData.fromScheme(scheme);
    return BoxDecoration(
      color: active ? resolved.pillColor : resolved.inactivePillColor,
      borderRadius: Coui.controlRadius,
      border: Border.all(
        color: active ? resolved.pillBorder : resolved.inactivePillBorder,
      ),
    );
  }
}

/// Presentation-only surfaces for the portrait video details area.
class VideoDetailBackground extends StatelessWidget {
  const VideoDetailBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final coui = CouiThemeData.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? [coui.surfaceBackground, coui.surfaceGradientEnd]
              : [
                  coui.surfaceBackground,
                  coui.surfaceGradientMid,
                  coui.surfaceGradientEnd,
                ],
          stops: dark ? const [0, 1] : const [0, 0.45, 1],
        ),
      ),
      child: child,
    );
  }
}

class VideoDetailCard extends StatelessWidget {
  const VideoDetailCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final coui = CouiThemeData.of(context);
    return DecoratedBox(
      decoration: Coui.cardDecoration(scheme, coui: coui),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: child,
      ),
    );
  }
}

class VideoDetailTabStrip extends StatelessWidget {
  const VideoDetailTabStrip({
    super.key,
    required this.controller,
    required this.tabs,
    required this.onTap,
    required this.showIndicator,
  });

  final TabController controller;
  final List<Widget> tabs;
  final ValueChanged<int> onTap;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final coui = CouiThemeData.of(context);
    return TabBar(
      padding: EdgeInsets.zero,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      splashBorderRadius: Coui.controlRadius,
      dividerHeight: 0,
      dividerColor: Colors.transparent,
      labelPadding: EdgeInsets.zero,
      controller: controller,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      indicator: showIndicator
          ? VideoDetailChrome.pillDecoration(scheme, coui: coui)
          : const BoxDecoration(),
      labelColor: showIndicator ? coui.accent : scheme.onSurface,
      unselectedLabelColor: scheme.onSurfaceVariant,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      onTap: onTap,
      tabs: tabs,
    );
  }
}
