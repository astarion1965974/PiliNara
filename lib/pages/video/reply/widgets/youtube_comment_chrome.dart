import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/common/widgets/coui_glass_surface.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/pages/video/widgets/detail_chrome.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

class YoutubeCommentSort extends StatefulWidget {
  const YoutubeCommentSort({
    super.key,
    required this.selected,
    required this.onSelect,
    this.totalCount,
  });

  final ReplySortType selected;
  final ValueChanged<ReplySortType> onSelect;
  final int? totalCount;

  @override
  State<YoutubeCommentSort> createState() => _YoutubeCommentSortState();
}

class _YoutubeCommentSortState extends State<YoutubeCommentSort>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;

  double _targetFor(ReplySortType type) =>
      type == ReplySortType.time ? 1.0 : 0.0;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController.unbounded(
      vsync: this,
      value: _targetFor(widget.selected),
    );
  }

  @override
  void didUpdateWidget(covariant YoutubeCommentSort oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected &&
        widget.selected != ReplySortType.select) {
      _slideController.animateWith(
        SpringSimulation(
          CouiMotion.switchToggleSpring,
          _slideController.value,
          _targetFor(widget.selected),
          0.0,
          tolerance: CouiMotion.springTolerance,
        ),
      );
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final count = widget.totalCount;

    Widget rightControl;
    if (widget.selected == ReplySortType.select) {
      rightControl = Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: VideoDetailChrome.inactivePill(scheme),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          border: Border.all(
            color: VideoDetailChrome.pillBorder(scheme, active: false),
          ),
        ),
        child: Text(
          '精选评论',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    } else {
      Widget segment(ReplySortType type, String label) {
        final active = widget.selected == type;
        return Expanded(
          child: Semantics(
            selected: active,
            button: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.onSelect(type),
              child: Container(
                height: 25,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active
                        ? VideoDetailChrome.accent(scheme)
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      rightControl = Container(
        height: 30,
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: VideoDetailChrome.inactivePill(scheme),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(
            color: VideoDetailChrome.pillBorder(scheme, active: false),
          ),
        ),
        child: IntrinsicWidth(
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _slideController,
                  builder: (context, child) {
                    final t = _slideController.value.clamp(0.0, 1.0);
                    return Align(
                      alignment: Alignment(t * 2.0 - 1.0, 0.0),
                      child: child,
                    );
                  },
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: VideoDetailChrome.pill(scheme),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.5),
                        ),
                        border: Border.all(
                          color: VideoDetailChrome.pillBorder(
                            scheme,
                            active: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  segment(ReplySortType.hot, '最热门'),
                  segment(ReplySortType.time, '最新'),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        Text(
          '全部评论',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        if (count != null && count >= 0) ...[
          const SizedBox(width: 6),
          Text(
            NumUtils.numFormat(count),
            style: TextStyle(
              fontSize: 12.5,
              color: scheme.outline,
            ),
          ),
        ],
        const Spacer(),
        rightControl,
      ],
    );
  }
}

class YoutubeCommentComposer extends StatelessWidget {
  const YoutubeCommentComposer({
    super.key,
    required this.bottomPadding,
    required this.onTap,
  });

  final double bottomPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    const capsuleRadius = BorderRadius.all(Radius.circular(28));
    return Padding(
      padding: EdgeInsets.fromLTRB(
        VideoDetailChrome.horizontalInset,
        8,
        VideoDetailChrome.horizontalInset,
        8 + bottomPadding,
      ),
      child: CouiGlassSurface(
        tier: CouiGlassTier.floating,
        borderRadius: capsuleRadius,
        child: Material(
          type: MaterialType.transparency,
          borderRadius: capsuleRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: capsuleRadius,
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '写评论…',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 14,
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

class YoutubeReplyThreadPainter extends CustomPainter {
  const YoutubeReplyThreadPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height <= 55) return;
    final end = size.height - 21;
    final path = Path()
      ..moveTo(17, 38)
      ..lineTo(17, end - 9)
      ..quadraticBezierTo(17, end, 27, end)
      ..lineTo(34, end);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(YoutubeReplyThreadPainter oldDelegate) =>
      color != oldDelegate.color;
}
