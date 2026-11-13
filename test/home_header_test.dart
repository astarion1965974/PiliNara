import 'package:PiliPlus/pages/home/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart'
    as custom_refresh;
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  test('partially visible header settles in the last drag direction', () {
    expect(homeHeaderSnapTarget(20, 1), homeHeaderHeight);
    expect(homeHeaderSnapTarget(90, -1), 0);
    expect(homeHeaderSnapTarget(20, 0), 0);
    expect(homeHeaderSnapTarget(90, 0), homeHeaderHeight);
    expect(homeHeaderSnapTarget(0, 1), 0);
    expect(homeHeaderSnapTarget(homeHeaderHeight, -1), homeHeaderHeight);
  });

  testWidgets('header snap animates and compensates the scroll position', (tester) async {
    final scroll = ScrollController();
    final offset = ValueNotifier<double>(20);
    final animator = HomeHeaderSnapAnimator(
      vsync: tester,
      readOffset: () => offset.value,
      writeOffset: (value) => offset.value = value,
    );
    addTearDown(animator.dispose);
    addTearDown(offset.dispose);
    addTearDown(scroll.dispose);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          controller: scroll,
          itemExtent: 50,
          itemCount: 100,
          itemBuilder: (_, index) => Text('item $index'),
        ),
      ),
    ));
    scroll.jumpTo(300);
    await tester.pump();
    animator.settle(position: scroll.position, target: homeHeaderHeight);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(offset.value, closeTo(homeHeaderHeight, 0.01));
    expect(scroll.position.pixels, closeTo(300 - (homeHeaderHeight - 20), 0.01));

    offset.value = 90;
    scroll.jumpTo(300);
    await tester.pump();
    animator.settle(position: scroll.position, target: 0);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(offset.value, closeTo(0, 0.01));
    expect(scroll.position.pixels, closeTo(390, 0.01));
  });

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

  test('HeaderRevealGate gates collapse at 12dp and reveal at 24dp/48dp without overscroll', () {
    final gate = HeaderRevealGate();

    // 12dp collapse threshold
    expect(gate.applyScrollDelta(6, pixels: 100), 0.0);
    expect(gate.applyScrollDelta(5, pixels: 105), 0.0);
    expect(gate.applyScrollDelta(2, pixels: 107), 2.0);

    // Sub-threshold jitter does not flip
    gate.reset();
    expect(gate.applyScrollDelta(8, pixels: 200), 0.0);
    expect(gate.applyScrollDelta(-10, pixels: 190), 0.0);
    expect(gate.applyScrollDelta(8, pixels: 198), 0.0);
    expect(gate.applyScrollDelta(-10, pixels: 188), 0.0);

    // 24dp + top (pixels <= 0) allows reveal
    gate.reset();
    expect(gate.applyScrollDelta(-15, pixels: 10), 0.0);
    expect(gate.applyScrollDelta(-10, pixels: 0), -10.0);

    // Deep in feed requires 48dp to reveal
    gate.reset();
    expect(gate.applyScrollDelta(-24, pixels: 300), 0.0);
    expect(gate.applyScrollDelta(-20, pixels: 280), 0.0);
    expect(gate.applyScrollDelta(-5, pixels: 275), -5.0);

    // Overscroll never triggers reveal
    gate.reset();
    expect(gate.applyScrollDelta(-60, pixels: 0, isOverscroll: true), 0.0);
  });

  test('custom RefreshIndicator defaults edgeOffset to 0.0', () {
    final indicator = custom_refresh.RefreshIndicator(
      onRefresh: () async {},
      child: const SizedBox.shrink(),
    );
    expect(indicator.edgeOffset, 0.0);
  });
}
