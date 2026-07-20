import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  // ---------------------------------------------------------------------------
  // toBeEnabled / toBeDisabled
  // ---------------------------------------------------------------------------
  group('toBeEnabled()', () {
    testWidgets('passes for an enabled ElevatedButton', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ElevatedButton(onPressed: () {}, child: const Text('Go')),
        ),
      );

      tester.expectThat(find.byType(ElevatedButton), matchers: [toBeEnabled()]);
    });

    testWidgets('fails for a disabled ElevatedButton', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: ElevatedButton(onPressed: null, child: Text('Go')),
        ),
      );

      expect(
        () => tester.expectThat(
          find.byType(ElevatedButton),
          matchers: [toBeEnabled()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('passes for an enabled TextField', (tester) async {
      await tester.pumpWidget(const TestApp(child: TextField(enabled: true)));

      tester.expectThat(find.byType(TextField), matchers: [toBeEnabled()]);
    });

    testWidgets('passes for an enabled TextFormField', (tester) async {
      await tester.pumpWidget(TestApp(child: TextFormField(enabled: true)));

      tester.expectThat(find.byType(TextFormField), matchers: [toBeEnabled()]);
    });
  });

  group('toBeDisabled()', () {
    testWidgets('passes for a disabled ElevatedButton', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: ElevatedButton(onPressed: null, child: Text('Go')),
        ),
      );

      tester.expectThat(
        find.byType(ElevatedButton),
        matchers: [toBeDisabled()],
      );
    });

    testWidgets('fails for an enabled ElevatedButton', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ElevatedButton(onPressed: () {}, child: const Text('Go')),
        ),
      );

      expect(
        () => tester.expectThat(
          find.byType(ElevatedButton),
          matchers: [toBeDisabled()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('passes for a disabled TextField', (tester) async {
      await tester.pumpWidget(const TestApp(child: TextField(enabled: false)));

      tester.expectThat(find.byType(TextField), matchers: [toBeDisabled()]);
    });

    testWidgets('passes for a disabled TextFormField', (tester) async {
      await tester.pumpWidget(TestApp(child: TextFormField(enabled: false)));

      tester.expectThat(find.byType(TextFormField), matchers: [toBeDisabled()]);
    });
  });

  // ---------------------------------------------------------------------------
  // toBeChecked / toBeUnchecked
  // ---------------------------------------------------------------------------
  group('toBeChecked()', () {
    testWidgets('passes for a checked Checkbox', (tester) async {
      await tester.pumpWidget(
        TestApp(child: Checkbox(value: true, onChanged: (_) {})),
      );

      tester.expectThat(find.byType(Checkbox), matchers: [toBeChecked()]);
    });

    testWidgets('fails for an unchecked Checkbox', (tester) async {
      await tester.pumpWidget(
        TestApp(child: Checkbox(value: false, onChanged: (_) {})),
      );

      expect(
        () =>
            tester.expectThat(find.byType(Checkbox), matchers: [toBeChecked()]),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('passes for a Switch that is on', (tester) async {
      await tester.pumpWidget(
        TestApp(child: Switch(value: true, onChanged: (_) {})),
      );

      tester.expectThat(find.byType(Switch), matchers: [toBeChecked()]);
    });
  });

  group('toBeUnchecked()', () {
    testWidgets('passes for an unchecked Checkbox', (tester) async {
      await tester.pumpWidget(
        TestApp(child: Checkbox(value: false, onChanged: (_) {})),
      );

      tester.expectThat(find.byType(Checkbox), matchers: [toBeUnchecked()]);
    });

    testWidgets('fails for a checked Checkbox', (tester) async {
      await tester.pumpWidget(
        TestApp(child: Checkbox(value: true, onChanged: (_) {})),
      );

      expect(
        () => tester.expectThat(
          find.byType(Checkbox),
          matchers: [toBeUnchecked()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('passes for a Switch that is off', (tester) async {
      await tester.pumpWidget(
        TestApp(child: Switch(value: false, onChanged: (_) {})),
      );

      tester.expectThat(find.byType(Switch), matchers: [toBeUnchecked()]);
    });
  });

  // ---------------------------------------------------------------------------
  // toHaveValue
  // ---------------------------------------------------------------------------
  group('toHaveValue()', () {
    testWidgets('passes when TextField has expected value', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: TextField(key: Key('name'))),
      );

      await tester.enterText(find.byKey(const Key('name')), 'Alice');
      await tester.pump();

      tester.expectThat(
        find.byKey(const Key('name')),
        matchers: [toHaveValue('Alice')],
      );
    });

    testWidgets('fails when value does not match', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: TextField(key: Key('name'))),
      );

      await tester.enterText(find.byKey(const Key('name')), 'Bob');
      await tester.pump();

      expect(
        () => tester.expectThat(
          find.byKey(const Key('name')),
          matchers: [toHaveValue('Alice')],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('works with TextFormField', (tester) async {
      await tester.pumpWidget(
        TestApp(child: TextFormField(key: const Key('field'))),
      );

      await tester.enterText(find.byKey(const Key('field')), 'Hello');
      await tester.pump();

      tester.expectThat(
        find.byKey(const Key('field')),
        matchers: [toHaveValue('Hello')],
      );
    });
  });
}
