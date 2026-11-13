import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart';

/// A compact settings switch using the dimensions of the COUI demo.
/// The value stays controlled by the caller, including during confirmation.
class CouiSwitch extends StatefulWidget {
  const CouiSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<CouiSwitch> createState() => _CouiSwitchState();
}

class _CouiSwitchState extends State<CouiSwitch> {
  double? _dragPosition;
  bool _pressed = false;

  void _finishDrag() {
    final position = _dragPosition;
    setState(() {
      _dragPosition = null;
      _pressed = false;
    });
    if (position == null) return;
    final next = position >= .5;
    if (next != widget.value) widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final coui = CouiThemeData.of(context);
    final enabled = widget.onChanged != null;
    final position = _dragPosition ?? (widget.value ? 1.0 : 0.0);
    final track = Color.lerp(
      coui.switchTrackOffColor,
      coui.switchTrackOnColor,
      position,
    )!;
    final rimColor = Color.lerp(
      coui.switchTrackRimInactiveColor,
      coui.switchTrackRimActiveColor,
      position,
    )!;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final activePress = _pressed || _dragPosition != null;

    return Semantics(
      toggled: widget.value,
      enabled: enabled,
      onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
        onHorizontalDragStart: enabled
            ? (_) => setState(() {
                _pressed = true;
                _dragPosition = widget.value ? 1 : 0;
              })
            : null,
        onHorizontalDragUpdate: enabled
            ? (details) => setState(() {
                final delta = (rtl ? -details.delta.dx : details.delta.dx) / 20;
                _dragPosition = ((_dragPosition ?? 0) + delta).clamp(0.0, 1.0);
              })
            : null,
        onHorizontalDragEnd: enabled ? (_) => _finishDrag() : null,
        onHorizontalDragCancel: enabled
            ? () => setState(() {
                _dragPosition = null;
                _pressed = false;
              })
            : null,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: _dragPosition == null ? 240 : 0),
              curve: Curves.easeOutCubic,
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: track.withValues(
                  alpha: enabled ? track.a : track.a * .45,
                ),
                border: Border.all(
                  color: rimColor,
                  width: 0.5,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: AnimatedAlign(
                duration: Duration(
                  milliseconds: _dragPosition == null ? 240 : 0,
                ),
                curve: Curves.easeOutCubic,
                alignment: Alignment((rtl ? -1 : 1) * (position * 2 - 1), 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  width: activePress ? 21 : 18,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: coui.switchThumbColor.withValues(
                      alpha: enabled ? 1 : .65,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .16),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
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
