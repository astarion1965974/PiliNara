import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';

class CouiNavigationDestination {
  const CouiNavigationDestination({required this.label, required this.icon});
  final String label;
  final Widget icon;
}

/// Flutter approximation of the COUI floating navigation material.
class CouiFloatingNavigation extends StatelessWidget {
  const CouiFloatingNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelection,
  });

  final List<CouiNavigationDestination> items;
  final int selectedIndex;
  final ValueChanged<int> onSelection;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final foreground = dark ? Colors.white : Colors.black;
    return SizedBox(
      width: items.length < 4 ? 260 : items.length * 68.0,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? .20 : .10),
              blurRadius: 22,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dark
                      ? [
                          const Color(0xff555055).withValues(alpha: .80),
                          const Color(0xff252326).withValues(alpha: .87),
                        ]
                      : [
                          Colors.white.withValues(alpha: .83),
                          const Color(0xfff2edf0).withValues(alpha: .78),
                        ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: foreground.withValues(alpha: dark ? .14 : .08),
                ),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: _NavigationItem(
                        destination: items[i],
                        selected: selectedIndex == i,
                        foreground: foreground,
                        onTap: () => onSelection(i),
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

class _NavigationItem extends StatefulWidget {
  const _NavigationItem({
    required this.destination,
    required this.selected,
    required this.foreground,
    required this.onTap,
  });
  final CouiNavigationDestination destination;
  final bool selected;
  final Color foreground;
  final VoidCallback onTap;

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.foreground.withValues(
      alpha: widget.selected ? .90 : .72,
    );
    return Semantics(
      selected: widget.selected,
      label: widget.destination.label,
      button: true,
      onTap: widget.onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          excludeFromSemantics: true,
          child: SizedBox(
            height: 48,
            child: AnimatedScale(
              scale: _pressed ? .92 : 1,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconTheme.merge(
                    data: IconThemeData(size: 24, color: color),
                    child: widget.destination.icon,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
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
