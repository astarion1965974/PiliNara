import 'package:PiliPlus/pages/video/widgets/detail_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('video tabs keep selection and tap callbacks', (tester) async {
    var tapped = -1;
    late TabController controller;
    await tester.pumpWidget(MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Builder(builder: (context) {
            controller = DefaultTabController.of(context);
            return VideoDetailBackground(
              child: Column(children: [
                VideoDetailTabStrip(
                  controller: controller,
                  tabs: const [Tab(text: '简介'), Tab(text: '评论')],
                  onTap: (index) => tapped = index,
                  showIndicator: true,
                ),
              ]),
            );
          }),
        ),
      ),
    ));
    await tester.tap(find.text('评论'));
    await tester.pumpAndSettle();
    expect(tapped, 1);
    expect(controller.index, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail card preserves its child button interaction', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: VideoDetailCard(
          child: TextButton(onPressed: () => taps++, child: const Text('测试')),
        ),
      ),
    ));
    await tester.tap(find.text('测试'));
    expect(taps, 1);
  });
}
