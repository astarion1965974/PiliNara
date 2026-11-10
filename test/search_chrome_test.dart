import 'package:PiliPlus/pages/search/widgets/search_chrome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('search entry keeps text input and submit callback', (tester) async {
    var submitted = '';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchBackground(
          child: SearchFieldSurface(
            child: TextField(onSubmitted: (value) => submitted = value),
          ),
        ),
      ),
    ));
    await tester.enterText(find.byType(TextField), '哔哩哔哩');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, '哔哩哔哩');
  });

  testWidgets('result search field remains tappable in dark mode', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SearchBackground(
          child: SearchFieldSurface(
            onTap: () => taps++,
            child: const Text('搜索结果'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('搜索结果'));
    expect(taps, 1);
  });
}
