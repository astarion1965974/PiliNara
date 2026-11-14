import 'dart:math' as math;

import 'package:PiliPlus/common/coui.dart';
import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

/// A COUI settings switch calibrated to CouiSwitchDefaults (44x24, 18dp thumb, 3dp padding)
/// and CouiSwitchMotion (toggle, drag, attach springs + stretch curve).
/// The value stays controlled by the caller, including during confirmation.
class CouiSwitch extends StatefulWidget {
  const CouiSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<CouiSwitch> createState() => _CouiSwitchState();
}

class _CouiSwitchState extends State<CouiSwitch> with TickerProviderStateMixin {
  late final AnimationController _positionController;
  late final AnimationController _pressController;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController.unbounded(
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    _pressController = AnimationController.unbounded(
      vsync: this,
      value: 0.0,
    );
  }

  @override
  void didUpdateWidget(CouiSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_dragging) {
      _animatePositionTo(widget.value ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _animatePositionTo(double target) {
    _positionController.animateWith(
      SpringSimulation(
        CouiMotion.switchToggleSpring,
        _positionController.value,
        target,
        _positionController.velocity,
        tolerance: CouiMotion.springTolerance,
      ),
    );
  }

  void _setPressed(bool pressed) {
    final spring = pressed
        ? CouiMotion.switchDragSpring
        : CouiMotion.switchAttachSpring;
    _pressController.animateWith(
      SpringSimulation(
        spring,
        _pressController.value,
        pressed ? 1.0 : 0.0,
        _pressController.velocity,
        tolerance: CouiMotion.springTolerance,
      ),
    );
  }

  void _finishDrag() {
    final position = _positionController.value;
    _dragging = false;
    _setPressed(false);
    final next = position >= 0.5;
    if (next != widget.value) {
      widget.onChanged?.call(next);
    }
    // Start returning to current widget.value; if parent updates widget.value
    // on rebuild, didUpdateWidget will redirect preserving velocity.
    _animatePositionTo(widget.value ? 1.0 : 0.0);
  }

  double _stretchForPosition(double p) {
    final clamped = p.clamp(0.0, 1.0);
    const peakP = 0.34725848;
    const peakGain = 0.29999995;
    if (clamped < peakP) {
      return 1.0 + (clamped / peakP) * peakGain;
    }
    return 1.3 - ((clamped - peakP) / (1.0 - peakP)) * peakGain;
  }

  @override
  Widget build(BuildContext context) {
    final coui = CouiThemeData.of(context);
    final enabled = widget.onChanged != null;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      toggled: widget.value,
      enabled: enabled,
      onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
        onHorizontalDragStart: enabled
            ? (_) {
                _dragging = true;
                _positionController.stop();
                _setPressed(true);
              }
            : null,
        onHorizontalDragUpdate: enabled
            ? (details) {
                final delta = (rtl ? -details.delta.dx : details.delta.dx) / 20;
                _positionController.value = (_positionController.value + delta)
                    .clamp(0.0, 1.0);
              }
            : null,
        onHorizontalDragEnd: enabled ? (_) => _finishDrag() : null,
        onHorizontalDragCancel: enabled
            ? () {
                _dragging = false;
                _setPressed(false);
                _animatePositionTo(widget.value ? 1.0 : 0.0);
              }
            : null,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _positionController,
                _pressController,
              ]),
              builder: (context, _) {
                final rawPos = _positionController.value;
                final colorPos = rawPos.clamp(0.0, 1.0);
                final pressVal = _pressController.value.clamp(0.0, 1.2);

                final trackColor = enabled
                    ? Color.lerp(
                        coui.switchTrackOffColor,
                        coui.switchTrackOnColor,
                        colorPos,
                      )!
                    : Color.lerp(
                        coui.switchDisabledTrackOffColor,
                        coui.switchDisabledTrackOnColor,
                        colorPos,
                      )!;
                final rimColor = Color.lerp(
                  coui.switchTrackRimInactiveColor,
                  coui.switchTrackRimActiveColor,
                  colorPos,
                )!;
                final thumbColor = enabled
                    ? coui.switchThumbColor
                    : coui.switchDisabledThumbColor;

                final toggleStretch = _stretchForPosition(rawPos);
                final pressStretch = 1.0 + pressVal * (21.0 / 18.0 - 1.0);
                final stretch = math.max(toggleStretch, pressStretch);
                final thumbWidth = (18.0 * stretch).clamp(18.0, 23.4);

                return Container(
                  width: 44,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: trackColor,
                    border: Border.all(
                      color: rimColor,
                      width: 0.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Align(
                    alignment: Alignment(
                      (rtl ? -1 : 1) * (rawPos * 2 - 1),
                      0,
                    ),
                    child: Container(
                      width: thumbWidth,
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: thumbColor,
                        boxShadow: enabled
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.16),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
