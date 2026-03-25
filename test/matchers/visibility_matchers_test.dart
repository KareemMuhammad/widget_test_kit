import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('toBeVisible()', () {
    testWidgets('passes for a visible widget', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Hello')),
      );

      tester.expectThat(find.text('Hello'), matchers: [toBeVisible()]);
    });

    testWidgets('fails when widget does not exist', (tester) async {
      await tester.pumpWidget(const TestApp(child: SizedBox()));

      expect(
        () => tester.expectThat(
          find.text('Missing'),
          matchers: [toBeVisible()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('fails when widget is inside Opacity(0)', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Opacity(opacity: 0, child: Text('Ghost')),
        ),
      );

      expect(
        () => tester.expectThat(
          find.text('Ghost'),
          matchers: [toBeVisible()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('fails when widget is inside Visibility(visible: false) with maintainState',
        (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Visibility(
            visible: false,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: Text('Hidden'),
          ),
        ),
      );

      // Widget exists in tree (maintainState + maintainSize) but is invisible.
      expect(
        () => tester.expectThat(
          find.text('Hidden'),
          matchers: [toBeVisible()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });
  });

  group('toBeHidden()', () {
    testWidgets('passes when widget is inside Opacity(0)', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Opacity(opacity: 0, child: Text('Ghost')),
        ),
      );

      tester.expectThat(find.text('Ghost'), matchers: [toBeHidden()]);
    });

    testWidgets('fails when widget is fully visible', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('Visible')));

      expect(
        () => tester.expectThat(
          find.text('Visible'),
          matchers: [toBeHidden()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('fails when widget does not exist at all', (tester) async {
      await tester.pumpWidget(const TestApp(child: SizedBox()));

      expect(
        () => tester.expectThat(
          find.text('Gone'),
          matchers: [toBeHidden()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });
  });

  group('toNotExist()', () {
    testWidgets('passes when widget is absent', (tester) async {
      await tester.pumpWidget(const TestApp(child: SizedBox()));

      tester.expectThat(find.text('Nope'), matchers: [toNotExist()]);
    });

    testWidgets('fails when widget exists', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('Here')));

      expect(
        () => tester.expectThat(
          find.text('Here'),
          matchers: [toNotExist()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });
  });
}

