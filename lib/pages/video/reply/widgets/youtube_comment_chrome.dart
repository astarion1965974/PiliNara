import 'package:PiliPlus/common/widgets/coui_glass_surface.dart';
import 'package:PiliPlus/common/widgets/coui_menu.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/pages/video/widgets/detail_chrome.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:material_ui/material_ui.dart';

class YoutubeCommentSort extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final count = totalCount;

    Widget rightControl;
    if (selected == ReplySortType.select) {
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
      final currentLabel = selected == ReplySortType.time ? '最新' : '最热门';
      rightControl = Builder(
        builder: (menuContext) => Semantics(
          button: true,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: () async {
              final next = await showCouiMenu<ReplySortType>(
                context: menuContext,
                items: [
                  CouiMenuItem<ReplySortType>(
                    label: '最热门',
                    value: ReplySortType.hot,
                    selected: selected == ReplySortType.hot,
                  ),
                  CouiMenuItem<ReplySortType>(
                    label: '最新',
                    value: ReplySortType.time,
                    selected: selected == ReplySortType.time,
                  ),
                ],
              );
              if (next != null) {
                onSelect(next);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
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
