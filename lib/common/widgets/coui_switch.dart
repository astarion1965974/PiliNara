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

  void _finishDrag() {
    final position = _dragPosition;
    setState(() => _dragPosition = null);
    if (position == null) return;
    final next = position >= .5;
    if (next != widget.value) widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = widget.onChanged != null;
    final dark = scheme.brightness == Brightness.dark;
    final position = _dragPosition ?? (widget.value ? 1.0 : 0.0);
    final track = Color.lerp(
      dark ? const Color(0x40ffffff) : const Color(0x29000000),
      scheme.primary,
      position,
    )!;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      toggled: widget.value,
      enabled: enabled,
      onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
        onHorizontalDragStart: enabled
            ? (_) => setState(() => _dragPosition = widget.value ? 1 : 0)
            : null,
        onHorizontalDragUpdate: enabled
            ? (details) => setState(() {
                final delta = (rtl ? -details.delta.dx : details.delta.dx) / 20;
                _dragPosition = ((_dragPosition ?? 0) + delta).clamp(0.0, 1.0);
              })
            : null,
        onHorizontalDragEnd: enabled ? (_) => _finishDrag() : null,
        onHorizontalDragCancel: enabled
            ? () => setState(() => _dragPosition = null)
            : null,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: _dragPosition == null ? 220 : 0),
              curve: Curves.easeOutCubic,
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: track.withValues(
                  alpha: enabled ? track.a : track.a * .45,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: AnimatedAlign(
                duration: Duration(
                  milliseconds: _dragPosition == null ? 220 : 0,
                ),
                curve: Curves.easeOutCubic,
                alignment: Alignment((rtl ? -1 : 1) * (position * 2 - 1), 0),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: enabled ? 1 : .65),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .14),
                        blurRadius: 2,
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
