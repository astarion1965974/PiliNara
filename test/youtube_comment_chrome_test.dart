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
          onSelect: (value) => selected = value,
        ),
      ),
    ));
    await tester.tap(find.text('最新'));
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
    await tester.tap(find.text('最新'), warnIfMissed: false);
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
    await tester.tap(find.text('写评论…'));
    expect(taps, 1);
    expect(tester.getSize(find.byType(YoutubeCommentComposer)).height, 84);
  });
}
