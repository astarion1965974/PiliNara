import 'package:PiliPlus/common/widgets/coui_glass_surface.dart';
import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/pages/video/widgets/detail_chrome.dart';
import 'package:material_ui/material_ui.dart';

class YoutubeCommentSort extends StatelessWidget {
  const YoutubeCommentSort({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final ReplySortType selected;
  final ValueChanged<ReplySortType> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    Widget button(ReplySortType type, String label) {
      final active = selected == type;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Semantics(
          selected: active,
          button: true,
          child: TextButton(
            onPressed: selected == ReplySortType.select
                ? null
                : () => onSelect(type),
            style: TextButton.styleFrom(
              backgroundColor: active
                  ? VideoDetailChrome.pill(scheme)
                  : VideoDetailChrome.inactivePill(scheme),
              foregroundColor: active
                  ? VideoDetailChrome.accent(scheme)
                  : scheme.onSurfaceVariant,
              side: BorderSide(
                color: VideoDetailChrome.pillBorder(scheme, active: active),
              ),
              shape: Coui.controlShape,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: const Size(0, 34),
              textStyle: TextStyle(
                fontSize: 13.5,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(label),
          ),
        ),
      );
    }

    return Row(children: [
      button(ReplySortType.hot, '最热门'),
      button(ReplySortType.time, '最新'),
      if (selected == ReplySortType.select)
        Text('精选评论', style: TextStyle(color: scheme.onSurfaceVariant)),
    ]);
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
    final coui = CouiThemeData.of(context);
    return CouiGlassSurface(
      tier: CouiGlassTier.chrome,
      topBorderOnly: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + bottomPadding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: coui.inputFillColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: coui.inputBorderColor,
              width: 0.75,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 44,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '写评论…',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
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

class YoutubeReplyThreadPainter extends CustomPainter {
  const YoutubeReplyThreadPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height <= 55) return;
    final end = size.height - 18;
    final path = Path()
      ..moveTo(17, 38)
      ..lineTo(17, end - 9)
      ..quadraticBezierTo(17, end, 27, end)
      ..lineTo(34, end);
    canvas.drawPath(path, Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(YoutubeReplyThreadPainter oldDelegate) =>
      color != oldDelegate.color;
}
