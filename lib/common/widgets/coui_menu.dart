import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/common/widgets/coui_glass_surface.dart';
import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

/// Base class for entries inside [CouiMenu].
sealed class CouiMenuEntry<T> {
  const CouiMenuEntry();
}

/// A selectable action item in a [CouiMenu].
class CouiMenuItem<T> extends CouiMenuEntry<T> {
  const CouiMenuItem({
    required this.label,
    this.icon,
    this.leading,
    this.value,
    this.onTap,
    this.selected = false,
    this.enabled = true,
    this.isDestructive = false,
  });

  final String label;
  final IconData? icon;
  final Widget? leading;
  final T? value;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;
  final bool isDestructive;
}

/// A visual divider placed strictly between groups in a [CouiMenu].
class CouiMenuDivider<T> extends CouiMenuEntry<T> {
  const CouiMenuDivider();
}

/// COUI floating glass menu container (168-260dp width, 20dp outer / 14dp inner radius).
class CouiMenu<T> extends StatelessWidget {
  const CouiMenu({
    super.key,
    required this.items,
    this.onSelected,
    this.minWidth = 168.0,
    this.maxWidth = 260.0,
  });

  final List<CouiMenuEntry<T>> items;
  final ValueChanged<T?>? onSelected;
  final double minWidth;
  final double maxWidth;

  static const double outerRadius = 20.0;
  static const double innerRadius = 14.0;
  static const double itemHeight = 44.0;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final coui = CouiThemeData.of(context);
    const radius = BorderRadius.all(Radius.circular(outerRadius));

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
      child: IntrinsicWidth(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.18 : 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CouiGlassSurface(
            tier: CouiGlassTier.floating,
            borderRadius: radius,
            child: Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final entry in items)
                      switch (entry) {
                        CouiMenuDivider<T>() => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            child: SizedBox(
                              height: 1,
                              child: ColoredBox(color: coui.dividerColor),
                            ),
                          ),
                        CouiMenuItem<T>() => _CouiMenuItemTile<T>(
                            item: entry,
                            onSelected: onSelected,
                          ),
                      },
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

class _CouiMenuItemTile<T> extends StatefulWidget {
  const _CouiMenuItemTile({
    required this.item,
    required this.onSelected,
  });

  final CouiMenuItem<T> item;
  final ValueChanged<T?>? onSelected;

  @override
  State<_CouiMenuItemTile<T>> createState() => _CouiMenuItemTileState<T>();
}

class _CouiMenuItemTileState<T> extends State<_CouiMenuItemTile<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  bool _pressed = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      value: 1.0,
      lowerBound: 0.96,
      upperBound: 1.0,
      duration: CouiMotion.pressDuration,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _setPressed(bool pressed) {
    if (!widget.item.enabled) return;
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
    if (pressed) {
      _pressController.animateTo(
        0.96,
        duration: CouiMotion.pressDuration,
        curve: CouiMotion.pressCurve,
      );
    } else {
      _pressController.animateWith(
        SpringSimulation(
          CouiMotion.pressDefaultSpring,
          _pressController.value,
          1.0,
          0.0,
          tolerance: CouiMotion.springTolerance,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final scheme = ColorScheme.of(context);
    final coui = CouiThemeData.of(context);
    final dark = scheme.brightness == Brightness.dark;

    final Color fgColor;
    if (item.isDestructive) {
      fgColor = scheme.error;
    } else if (item.selected) {
      fgColor = coui.accent;
    } else {
      fgColor = scheme.onSurface;
    }

    final Color? bgColor;
    if (!item.enabled) {
      bgColor = null;
    } else if (_pressed) {
      bgColor = item.selected
          ? coui.pillColor
          : scheme.onSurface.withValues(alpha: dark ? 0.12 : 0.08);
    } else if (item.selected) {
      bgColor = coui.navSelectedPillColor;
    } else if (_hovered) {
      bgColor = scheme.onSurface.withValues(alpha: dark ? 0.06 : 0.04);
    } else {
      bgColor = null;
    }

    final Widget? leadingWidget = item.leading ??
        (item.icon != null ? Icon(item.icon, size: 18, color: fgColor) : null);

    Widget content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: CouiMenu.itemHeight),
      child: AnimatedContainer(
        duration: CouiMotion.pressDuration,
        curve: CouiMotion.pressCurve,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(CouiMenu.innerRadius),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingWidget != null) ...[
              IconTheme(
                data: IconThemeData(size: 18, color: fgColor),
                child: leadingWidget,
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: fgColor,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!item.enabled) {
      content = Opacity(opacity: 0.38, child: content);
    }

    return Semantics(
      button: true,
      enabled: item.enabled,
      selected: item.selected,
      child: MouseRegion(
        cursor: item.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: item.enabled ? (_) => _setPressed(true) : null,
          onTapUp: item.enabled ? (_) => _setPressed(false) : null,
          onTapCancel: item.enabled ? () => _setPressed(false) : null,
          onTap: item.enabled
              ? () {
                  item.onTap?.call();
                  widget.onSelected?.call(item.value);
                }
              : null,
          child: ScaleTransition(
            scale: _pressController,
            child: content,
          ),
        ),
      ),
    );
  }
}

/// Shows a COUI floating menu anchored to [anchorContext], [offset], or [context].
Future<T?> showCouiMenu<T>({
  required BuildContext context,
  BuildContext? anchorContext,
  Offset? offset,
  required List<CouiMenuEntry<T>> items,
  double minWidth = 168.0,
  double maxWidth = 260.0,
  bool useRootNavigator = false,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final overlayBox = navigator.overlay!.context.findRenderObject() as RenderBox;

  final Rect anchorRect;
  if (anchorContext != null) {
    final box = anchorContext.findRenderObject() as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlayBox);
    anchorRect = topLeft & box.size;
  } else if (offset != null) {
    final local = overlayBox.globalToLocal(offset);
    anchorRect = Rect.fromLTWH(local.dx, local.dy, 0, 0);
  } else {
    final box = context.findRenderObject() as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlayBox);
    anchorRect = topLeft & box.size;
  }

  return navigator.push<T>(
    _CouiMenuRoute<T>(
      anchorRect: anchorRect,
      items: items,
      minWidth: minWidth,
      maxWidth: maxWidth,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
    ),
  );
}

class _CouiMenuRoute<T> extends PopupRoute<T> {
  _CouiMenuRoute({
    required this.anchorRect,
    required this.items,
    required this.minWidth,
    required this.maxWidth,
    required this.capturedThemes,
  });

  final Rect anchorRect;
  final List<CouiMenuEntry<T>> items;
  final double minWidth;
  final double maxWidth;
  final CapturedThemes capturedThemes;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 340);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 240);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => '关闭菜单';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final mediaPadding = MediaQuery.paddingOf(context);
    final child = _CouiMenuSpringTransition(
      routeAnimation: animation,
      anchorRect: anchorRect,
      mediaPadding: mediaPadding,
      child: CouiMenu<T>(
        items: items,
        minWidth: minWidth,
        maxWidth: maxWidth,
        onSelected: (value) => Navigator.of(context).pop<T>(value),
      ),
    );
    return capturedThemes.wrap(
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        child: CustomSingleChildLayout(
          delegate: _CouiMenuPositionDelegate(
            anchorRect: anchorRect,
            mediaPadding: mediaPadding,
            safeMargin: 12.0,
            gap: 6.0,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CouiMenuSpringTransition extends StatefulWidget {
  const _CouiMenuSpringTransition({
    required this.routeAnimation,
    required this.anchorRect,
    required this.mediaPadding,
    required this.child,
  });

  final Animation<double> routeAnimation;
  final Rect anchorRect;
  final EdgeInsets mediaPadding;
  final Widget child;

  @override
  State<_CouiMenuSpringTransition> createState() =>
      _CouiMenuSpringTransitionState();
}

class _CouiMenuSpringTransitionState extends State<_CouiMenuSpringTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _springController;
  bool _exiting = false;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController.unbounded(vsync: this, value: 0.0);
    _springController.animateWith(
      SpringSimulation(
        CouiMotion.spring(response: 0.34, bounce: 0.18),
        0.0,
        1.0,
        0.0,
        tolerance: CouiMotion.springTolerance,
      ),
    );
    widget.routeAnimation.addStatusListener(_onRouteStatus);
  }

  void _onRouteStatus(AnimationStatus status) {
    if (status == AnimationStatus.reverse && !_exiting) {
      _exiting = true;
      _springController.animateWith(
        SpringSimulation(
          CouiMotion.spring(response: 0.24, bounce: 0.0),
          _springController.value,
          0.0,
          0.0,
          tolerance: CouiMotion.springTolerance,
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.routeAnimation.removeStatusListener(_onRouteStatus);
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final alignRight = widget.anchorRect.center.dx >= screen.width / 2;
    final alignBottom =
        widget.anchorRect.bottom + 6.0 + 180.0 > screen.height - widget.mediaPadding.bottom - 12.0 &&
            widget.anchorRect.top > screen.height / 2;

    final Alignment anchorAlignment;
    if (alignBottom) {
      anchorAlignment =
          alignRight ? Alignment.bottomRight : Alignment.bottomLeft;
    } else {
      anchorAlignment = alignRight ? Alignment.topRight : Alignment.topLeft;
    }

    return AnimatedBuilder(
      animation: _springController,
      builder: (context, child) {
        final v = _springController.value;
        final scale = 0.86 + 0.14 * v;
        final opacity = v.clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            alignment: anchorAlignment,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _CouiMenuPositionDelegate extends SingleChildLayoutDelegate {
  _CouiMenuPositionDelegate({
    required this.anchorRect,
    required this.mediaPadding,
    required this.safeMargin,
    required this.gap,
  });

  final Rect anchorRect;
  final EdgeInsets mediaPadding;
  final double safeMargin;
  final double gap;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final maxW = (constraints.maxWidth - mediaPadding.horizontal - safeMargin * 2)
        .clamp(0.0, constraints.maxWidth);
    final maxH = (constraints.maxHeight - mediaPadding.vertical - safeMargin * 2)
        .clamp(0.0, constraints.maxHeight);
    return BoxConstraints.loose(Size(maxW, maxH));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final minX = mediaPadding.left + safeMargin;
    final maxX = (size.width - mediaPadding.right - safeMargin - childSize.width)
        .clamp(minX, size.width);
    final minY = mediaPadding.top + safeMargin;
    final maxY =
        (size.height - mediaPadding.bottom - safeMargin - childSize.height)
            .clamp(minY, size.height);

    final preferRight = anchorRect.center.dx >= size.width / 2;
    double x = preferRight
        ? anchorRect.right - childSize.width
        : anchorRect.left;
    x = x.clamp(minX, maxX);

    double y = anchorRect.bottom + gap;
    if (y + childSize.height > size.height - mediaPadding.bottom - safeMargin) {
      final flippedY = anchorRect.top - gap - childSize.height;
      if (flippedY >= minY || anchorRect.top > size.height / 2) {
        y = flippedY;
      }
    }
    y = y.clamp(minY, maxY);

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_CouiMenuPositionDelegate oldDelegate) {
    return anchorRect != oldDelegate.anchorRect ||
        mediaPadding != oldDelegate.mediaPadding ||
        safeMargin != oldDelegate.safeMargin ||
        gap != oldDelegate.gap;
  }
}
