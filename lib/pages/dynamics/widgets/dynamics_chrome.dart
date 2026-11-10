import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/pages/video/widgets/detail_chrome.dart';
import 'package:material_ui/material_ui.dart';

/// Dynamics chrome shares the portrait COUI surfaces used by video and search.
class DynamicsBackground extends StatelessWidget {
  const DynamicsBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => VideoDetailBackground(child: child);
}

class DynamicsTabStrip extends StatelessWidget {
  const DynamicsTabStrip({
    super.key,
    required this.controller,
    required this.tabs,
    required this.onTap,
  });

  final TabController controller;
  final List<Widget> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    return TabBar(
      controller: controller,
      tabs: tabs,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerHeight: 0,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      indicator: BoxDecoration(
        color: VideoDetailChrome.pill(scheme),
        borderRadius: Coui.controlRadius,
      ),
      labelColor: VideoDetailChrome.accent(scheme),
      unselectedLabelColor: scheme.onSurfaceVariant,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 14),
      splashBorderRadius: Coui.controlRadius,
      onTap: onTap,
    );
  }
}

class DynamicsComposeButton extends StatelessWidget {
  const DynamicsComposeButton({
    super.key,
    required this.onPressed,
    this.margin = const EdgeInsets.only(right: 12),
  });

  final VoidCallback onPressed;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final accent = VideoDetailChrome.accent(scheme);
    return Padding(
      padding: margin,
      child: Material(
        color: VideoDetailChrome.pill(scheme),
        borderRadius: Coui.controlRadius,
        child: InkWell(
          borderRadius: Coui.controlRadius,
          onTap: onPressed,
          child: SizedBox(
            height: 34,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 16, color: accent),
                  const SizedBox(width: 4),
                  Text(
                    '发布',
                    style: TextStyle(
                      color: accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Feed card surface. Detail and save views stay flat.
class DynamicsFeedCard extends StatelessWidget {
  const DynamicsFeedCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final dark = scheme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: dark
              ? scheme.surfaceContainerHigh.withValues(alpha: 0.92)
              : Colors.white.withValues(alpha: 0.94),
          borderRadius: Coui.cardRadius,
        ),
        child: ClipRRect(
          borderRadius: Coui.cardRadius,
          child: child,
        ),
      ),
    );
  }
}
