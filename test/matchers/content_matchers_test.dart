import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_helper/widget_test_helper.dart';

void main() {
  // ---------------------------------------------------------------------------
  // toHaveText
  // ---------------------------------------------------------------------------
  group('toHaveText()', () {
    testWidgets('passes when Text widget has exact data', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('Hello')));

      tester.expectThat(find.text('Hello'), matchers: [toHaveText('Hello')]);
    });

    testWidgets('passes when a descendant Text matches', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Card(child: Text('Title')),
        ),
      );

      tester.expectThat(
        find.byType(Card),
        matchers: [toHaveText('Title')],
      );
    });

    testWidgets('fails when text does not match', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('Hello')));

      expect(
        () => tester.expectThat(
          find.text('Hello'),
          matchers: [toHaveText('World')],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('fails when no descendant has the text', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Card(child: Text('Other'))),
      );

      expect(
        () => tester.expectThat(
          find.byType(Card),
          matchers: [toHaveText('Missing')],
        ),
        throwsA(isA<TestFailure>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // toContainText
  // ---------------------------------------------------------------------------
  group('toContainText()', () {
    testWidgets('passes when Text data contains substring', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Hello, World!')),
      );

      tester.expectThat(
        find.text('Hello, World!'),
        matchers: [toContainText('World')],
      );
    });

    testWidgets('passes when descendant text contains substring',
        (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Card(child: Text('Registration complete!')),
        ),
      );

      tester.expectThat(
        find.byType(Card),
        matchers: [toContainText('complete')],
      );
    });

    testWidgets('fails when substring is not found', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('Hello')));

      expect(
        () => tester.expectThat(
          find.text('Hello'),
          matchers: [toContainText('xyz')],
        ),
        throwsA(isA<TestFailure>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // toHaveSemantics
  // ---------------------------------------------------------------------------
  group('toHaveSemantics()', () {
    testWidgets('passes when semantics label matches', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        TestApp(
          child: Semantics(
            key: const Key('close_btn'),
            label: 'Close dialog',
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {},
            ),
          ),
        ),
      );

      tester.expectThat(
        find.byKey(const Key('close_btn')),
        matchers: [toHaveSemantics('Close dialog')],
      );

      handle.dispose();
    });

    testWidgets('fails when semantics label does not match', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        TestApp(
          child: Semantics(
            key: const Key('menu_btn'),
            label: 'Open menu',
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(
        () => tester.expectThat(
          find.byKey(const Key('menu_btn')),
          matchers: [toHaveSemantics('Close dialog')],
        ),
        throwsA(isA<TestFailure>()),
      );

      handle.dispose();
    });
  });
}

