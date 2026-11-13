import 'package:PiliPlus/common/widgets/coui_floating_navigation.dart';
import 'package:PiliPlus/common/widgets/coui_switch.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/coui_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' as mui;

void main() {
  testWidgets('switch follows controlled value after a tap', (tester) async {
    var value = false;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Center(
            child: CouiSwitch(
              value: value,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(CouiSwitch));
    await tester.pumpAndSettle();
    expect(value, isTrue);
    await tester.tap(find.byType(CouiSwitch));
    await tester.pumpAndSettle();
    expect(value, isFalse);
  });

  testWidgets('switch drag commits only the changed value', (tester) async {
    var value = false;
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Center(
            child: CouiSwitch(
              value: value,
              onChanged: (next) => setState(() {
                value = next;
                calls++;
              }),
            ),
          ),
        ),
      ),
    );
    await tester.drag(find.byType(CouiSwitch), const Offset(35, 0));
    await tester.pumpAndSettle();
    expect(value, isTrue);
    expect(calls, 1);
  });

  testWidgets('navigation reports the chosen destination', (tester) async {
    var selection = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Center(
            child: CouiFloatingNavigation(
              selectedIndex: selection,
              onSelection: (next) => setState(() => selection = next),
              items: const [
                CouiNavigationDestination(label: '首页', icon: Icon(Icons.home)),
                CouiNavigationDestination(label: '动态', icon: Icon(Icons.feed)),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('动态'));
    await tester.pumpAndSettle();
    expect(selection, 1);
  });

  testWidgets('setting groups keep row callbacks and separate custom content', (
    tester,
  ) async {
    var tapped = false;
    final settings = <SettingsModel>[
      NormalModel(
        title: '第一项',
        leading: const Icon(Icons.settings),
        onTap: (_, _) => tapped = true,
      ),
      const NormalModel(title: '第二项'),
      const WidgetModel(child: Text('自定义内容')),
      const NormalModel(title: '第三项'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              for (var i = 0; i < settings.length; i++)
                CouiSettingRow(settings: settings, index: i),
            ],
          ),
        ),
      ),
    );
    expect(find.byType(mui.Divider), findsOneWidget);
    expect(find.text('自定义内容'), findsOneWidget);
    await tester.tap(find.text('第一项'));
    expect(tapped, isTrue);
  });
}
