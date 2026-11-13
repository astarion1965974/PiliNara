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
      indicator: VideoDetailChrome.pillDecoration(
        scheme,
        coui: CouiThemeData.of(context),
      ),
      labelColor: CouiThemeData.of(context).accent,
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
    final coui = CouiThemeData.of(context);
    final accent = coui.accent;
    return Padding(
      padding: margin,
      child: DecoratedBox(
        decoration: VideoDetailChrome.pillDecoration(scheme, coui: coui),
        child: Material(
          type: MaterialType.transparency,
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
    final coui = CouiThemeData.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
      child: DecoratedBox(
        decoration: Coui.cardDecoration(scheme, coui: coui),
        child: ClipRRect(
          borderRadius: Coui.cardRadius,
          child: child,
        ),
      ),
    );
  }
}
