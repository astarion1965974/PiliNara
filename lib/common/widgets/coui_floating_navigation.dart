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
    final accent = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: items.length < 4 ? 260 : items.length * 68.0,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? .30 : .12),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? .12 : .04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: CustomPaint(
              painter: _CouiContourRimPainter(
                radius: 28,
                topColor: Colors.white.withValues(alpha: dark ? .28 : .86),
                bottomColor: foreground.withValues(alpha: dark ? .10 : .07),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: dark
                        ? [
                            const Color(0xff585258).withValues(alpha: .72),
                            const Color(0xff201e22).withValues(alpha: .84),
                          ]
                        : [
                            Colors.white.withValues(alpha: .84),
                            const Color(0xfff4eef1).withValues(alpha: .74),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Expanded(
                          child: _NavigationItem(
                            destination: items[i],
                            selected: selectedIndex == i,
                            foreground: foreground,
                            accent: accent,
                            dark: dark,
                            onTap: () => onSelection(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CouiContourRimPainter extends CustomPainter {
  const _CouiContourRimPainter({
    required this.radius,
    required this.topColor,
    required this.bottomColor,
  });

  final double radius;
  final Color topColor;
  final Color bottomColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.5),
      Radius.circular(radius),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [topColor, bottomColor],
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_CouiContourRimPainter oldDelegate) =>
      radius != oldDelegate.radius ||
      topColor != oldDelegate.topColor ||
      bottomColor != oldDelegate.bottomColor;
}

class _NavigationItem extends StatefulWidget {
  const _NavigationItem({
    required this.destination,
    required this.selected,
    required this.foreground,
    required this.accent,
    required this.dark,
    required this.onTap,
  });
  final CouiNavigationDestination destination;
  final bool selected;
  final Color foreground;
  final Color accent;
  final bool dark;
  final VoidCallback onTap;

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.selected
        ? widget.foreground.withValues(alpha: .95)
        : widget.foreground.withValues(alpha: .64);
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
              scale: _pressed ? .90 : 1,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                decoration: BoxDecoration(
                  color: widget.selected
                      ? widget.accent.withValues(alpha: widget.dark ? .20 : .12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: widget.selected
                      ? Border.all(
                          color: widget.accent.withValues(
                            alpha: widget.dark ? .24 : .16,
                          ),
                          width: 0.75,
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconTheme.merge(
                      data: IconThemeData(size: 22, color: color),
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
                        fontWeight: widget.selected
                            ? FontWeight.w600
                            : FontWeight.w500,
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
