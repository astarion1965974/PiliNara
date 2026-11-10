import 'package:material_ui/material_ui.dart';

/// Shared colors for the portrait detail page and its floating bars.
class VideoDetailChrome {
  static Color background(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
          ? const Color(0xff282025)
          : const Color(0xfffff1f5);

  static Color accent(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
          ? const Color(0xffffa2bb)
          : const Color(0xffc6436c);

  static Color pill(ColorScheme scheme) => accent(scheme).withValues(
    alpha: scheme.brightness == Brightness.dark ? 0.18 : 0.10,
  );
}

/// Presentation-only surfaces for the portrait video details area.
class VideoDetailBackground extends StatelessWidget {
  const VideoDetailBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? const [Color(0xff282025), Color(0xff181619)]
              : const [Color(0xfffff1f5), Color(0xfffdfbfc), Color(0xfff8f9fa)],
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
    final dark = scheme.brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark
            ? scheme.surfaceContainerHigh.withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
      ),
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
    final accent = VideoDetailChrome.accent(scheme);
    return TabBar(
      padding: EdgeInsets.zero,
      dividerHeight: 0,
      dividerColor: Colors.transparent,
      labelPadding: EdgeInsets.zero,
      controller: controller,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      indicator: showIndicator
          ? BoxDecoration(
              color: VideoDetailChrome.pill(scheme),
              borderRadius: BorderRadius.circular(18),
            )
          : const BoxDecoration(),
      labelColor: showIndicator ? accent : scheme.onSurface,
      unselectedLabelColor: scheme.onSurfaceVariant,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      onTap: onTap,
      tabs: tabs,
    );
  }
}
