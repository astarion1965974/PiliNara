import 'package:PiliPlus/pages/dynamics/widgets/dynamics_chrome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('dynamics tabs keep pill selection and compose stays tappable', (
    tester,
  ) async {
    var composed = 0;
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  DynamicsTabStrip(
                    controller: DefaultTabController.of(context),
                    tabs: const [Tab(text: '全部'), Tab(text: '投稿')],
                    onTap: (index) => selected = index,
                  ),
                  DynamicsComposeButton(onPressed: () => composed++),
                  const DynamicsFeedCard(child: Text('动态卡片')),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('投稿'));
    await tester.tap(find.text('发布'));
    expect(selected, 1);
    expect(composed, 1);
    expect(find.text('动态卡片'), findsOneWidget);
  });
}
