import 'package:PiliPlus/pages/home/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  testWidgets('bilibili vector wordmark loads', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SvgPicture.asset('assets/images/bilibili_wordmark.svg'),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('title and search collapse in one clipped surface', (tester) async {
    var titleTaps = 0;
    var searchTaps = 0;
    Widget screen(double offset) => MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 200,
            child: HomeHeaderClip(
              offset: offset,
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => titleTaps++,
                    child: const SizedBox(
                      width: double.infinity,
                      height: homeTitleBarHeight,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => searchTaps++,
                    child: const SizedBox(width: double.infinity, height: 52),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(screen(0));
    expect(tester.getSize(find.byType(HomeHeaderClip)).height, homeHeaderHeight);

    await tester.pumpWidget(screen(60));
    expect(tester.getSize(find.byType(HomeHeaderClip)).height, homeHeaderHeight - 60);
    final origin = tester.getTopLeft(find.byType(HomeHeaderClip));
    await tester.tapAt(origin + const Offset(20, 10));
    await tester.tapAt(origin + const Offset(20, 55));
    expect(titleTaps, 0);
    expect(searchTaps, 1);

    await tester.pumpWidget(screen(homeHeaderHeight));
    expect(tester.getSize(find.byType(HomeHeaderClip)).height, 0);
    await tester.tapAt(origin + const Offset(20, 10));
    expect(titleTaps, 0);
    expect(searchTaps, 1);
  });

  testWidgets('instant mode animates the whole header out and back', (tester) async {
    final visible = ValueNotifier<bool>(true);
    addTearDown(visible.dispose);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (context, show, _) => TweenAnimationBuilder<double>(
              tween: Tween(end: show ? 0 : homeHeaderHeight),
              duration: const Duration(milliseconds: 350),
              builder: (context, offset, _) => HomeHeaderClip(
                offset: offset,
                child: const SizedBox(height: homeHeaderHeight),
              ),
            ),
          ),
        ),
      ),
    ));
    expect(tester.getSize(find.byType(HomeHeaderClip)).height, homeHeaderHeight);
    visible.value = false;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 175));
    expect(tester.getSize(find.byType(HomeHeaderClip)).height,
        inExclusiveRange(0, homeHeaderHeight));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(HomeHeaderClip)).height, 0);
    visible.value = true;
    await tester.pump();
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(HomeHeaderClip)).height, homeHeaderHeight);
  });
}
