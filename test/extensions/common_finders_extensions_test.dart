import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('find.button()', () {
    testWidgets('finds ElevatedButton by label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ElevatedButton(onPressed: () {}, child: const Text('Go')),
        ),
      );

      expect(find.button('Go'), findsOneWidget);
    });

    testWidgets('finds TextButton by label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: TextButton(onPressed: () {}, child: const Text('Cancel')),
        ),
      );

      expect(find.button('Cancel'), findsOneWidget);
    });

    testWidgets('finds OutlinedButton by label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child:
              OutlinedButton(onPressed: () {}, child: const Text('Details')),
        ),
      );

      expect(find.button('Details'), findsOneWidget);
    });

    testWidgets('finds FilledButton by label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: FilledButton(onPressed: () {}, child: const Text('Save')),
        ),
      );

      expect(find.button('Save'), findsOneWidget);
    });

    testWidgets('returns findsNothing when no button matches', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Not a button')),
      );

      expect(find.button('Not a button'), findsNothing);
    });
  });
}

