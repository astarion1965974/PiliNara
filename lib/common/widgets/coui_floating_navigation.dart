import 'dart:ui' show ImageFilter;

import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/common/widgets/coui_contour_box.dart';
import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

class CouiNavigationDestination {
  const CouiNavigationDestination({required this.label, required this.icon});
  final String label;
  final Widget icon;
}

/// Flutter approximation of the COUI floating navigation material backed by [CouiThemeData.glassFloating].
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
    final coui = CouiThemeData.of(context);
    final floating = coui.glassFloating;
    final capsuleRadius = BorderRadius.circular(28);
    return SizedBox(
      width: items.length < 4 ? 260 : items.length * 68.0,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: capsuleRadius,
          boxShadow: [
            BoxShadow(
              color: floating.shadowColor,
              blurRadius: floating.shadowBlur,
              offset: floating.shadowOffset,
            ),
            BoxShadow(
              color: coui.shadowColor,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: capsuleRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: floating.blurSigma,
              sigmaY: floating.blurSigma,
            ),
            child: CouiContourBox(
              borderRadius: capsuleRadius,
              style: CouiContourStyle.menu,
              topColor: floating.highlightColor,
              bottomColor: floating.borderColor,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [floating.fillColor, floating.fillEndColor],
                  ),
                  borderRadius: capsuleRadius,
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
                            coui: coui,
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

class _NavigationItem extends StatefulWidget {
  const _NavigationItem({
    required this.destination,
    required this.selected,
    required this.coui,
    required this.onTap,
  });
  final CouiNavigationDestination destination;
  final bool selected;
  final CouiThemeData coui;
  final VoidCallback onTap;

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController.unbounded(
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onHighlightChanged(bool pressed) {
    final spring = pressed
        ? CouiMotion.pressDefaultSpring
        : CouiMotion.releaseDefaultSpring;
    _scaleController.animateWith(
      SpringSimulation(
        spring,
        _scaleController.value,
        pressed ? 0.90 : 1.0,
        _scaleController.velocity,
        tolerance: CouiMotion.springTolerance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = widget.coui.navForeground;
    final color = widget.selected
        ? foreground.withValues(alpha: .95)
        : foreground.withValues(alpha: .64);
    return Semantics(
      selected: widget.selected,
      label: widget.destination.label,
      button: true,
      onTap: widget.onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: _onHighlightChanged,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          excludeFromSemantics: true,
          child: SizedBox(
            height: 48,
            child: AnimatedBuilder(
              animation: _scaleController,
              builder: (context, child) => Transform.scale(
                scale: _scaleController.value,
                child: child,
              ),
              child: AnimatedContainer(
                duration: CouiMotion.stateDuration,
                curve: CouiMotion.stateCurve,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                decoration: BoxDecoration(
                  color: widget.selected
                      ? widget.coui.navSelectedPillColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: widget.selected
                      ? Border.all(
                          color: widget.coui.navSelectedBorderColor,
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
