import 'package:PiliPlus/common/widgets/coui_glass_surface.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/pages/video/reply/widgets/youtube_comment_chrome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('sort buttons send the requested sort', (tester) async {
    ReplySortType? selected;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YoutubeCommentSort(
          selected: ReplySortType.hot,
          totalCount: 128,
          onSelect: (value) => selected = value,
        ),
      ),
    ));
    expect(find.text('全部评论'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    await tester.tap(find.text('最热门'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('最新'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(selected, ReplySortType.time);
  });

  testWidgets('curated-only sorting is not falsely switchable', (tester) async {
    var calls = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YoutubeCommentSort(
          selected: ReplySortType.select,
          onSelect: (_) => calls++,
        ),
      ),
    ));
    expect(find.text('精选评论'), findsOneWidget);
    expect(find.text('最热门'), findsNothing);
    expect(find.text('最新'), findsNothing);
    await tester.tap(find.text('精选评论'), warnIfMissed: false);
    expect(calls, 0);
  });

  testWidgets('composer opens reply flow with safe area reserved', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: YoutubeCommentComposer(
            bottomPadding: 24,
            onTap: () => taps++,
          ),
        ),
      ),
    ));
    expect(find.byType(CouiGlassSurface), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    await tester.tap(find.text('写评论…'));
    expect(taps, 1);
    // 8 (top) + 56 (capsule) + 8 (bottom) + 24 (bottomPadding) = 96
    expect(tester.getSize(find.byType(YoutubeCommentComposer)).height, 96);
  });
}
