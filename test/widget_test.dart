import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaomoji_keyboard/main.dart';

void main() {
  testWidgets('companion tabs render and font preview transforms typed text', (tester) async {
    await tester.pumpWidget(const KaomojiApp());
    expect(find.text('Pick your feeling'), findsOneWidget);

    await tester.tap(find.text('Fonts'));
    await tester.pumpAndSettle();
    expect(find.text('Text, but make it ✨'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.tap(find.text('Bold'));
    await tester.pumpAndSettle();
    expect(find.text('𝐡𝐞𝐥𝐥𝐨'), findsOneWidget);

    await tester.tap(find.text('Backgrounds'));
    await tester.pumpAndSettle();
    expect(find.text('Set the scene'), findsOneWidget);
    expect(find.text('Ocean'), findsOneWidget);
  });
}
