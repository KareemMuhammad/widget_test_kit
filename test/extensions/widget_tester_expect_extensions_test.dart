import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('expectThat', () {
    testWidgets('passes when all matchers pass', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Hello')),
      );

      // Should not throw.
      tester.expectThat(
        find.text('Hello'),
        matchers: [toBeVisible()],
      );
    });

    testWidgets('fails when any matcher fails', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: SizedBox()),
      );

      expect(
        () => tester.expectThat(
          find.text('Missing'),
          matchers: [toBeVisible()],
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    testWidgets('prepends reason to failure message', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: SizedBox()),
      );

      try {
        tester.expectThat(
          find.text('Nope'),
          matchers: [toBeVisible()],
          reason: 'Login banner should appear',
        );
        fail('Expected TestFailure');
      } on TestFailure catch (e) {
        expect(e.message, contains('Login banner should appear'));
      }
    });

    testWidgets('evaluates multiple matchers in order', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: ElevatedButton(onPressed: _noop, child: Text('Go')),
        ),
      );

      // Both matchers should pass.
      tester.expectThat(
        find.byType(ElevatedButton),
        matchers: [toBeVisible(), toBeEnabled()],
      );
    });
  });

  group('expectThatSingle', () {
    testWidgets('delegates to expectThat with single matcher', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Hi')),
      );

      tester.expectThatSingle(
        find.text('Hi'),
        matcher: toBeVisible(),
      );
    });
  });

  group('shouldBe', () {
    testWidgets('is a terse alias for expectThat', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: SizedBox()),
      );

      tester.shouldBe(find.byType(CircularProgressIndicator), toNotExist());
    });
  });

  group('expectThatEventually', () {
    testWidgets('succeeds immediately when matchers pass', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Already here')),
      );

      await tester.expectThatEventually(
        find.text('Already here'),
        matchers: [toBeVisible()],
      );
    });

    testWidgets('polls until matchers pass', (tester) async {
      // Widget that shows "Done" after a rebuild triggered by a timer.
      await tester.pumpWidget(
        const TestApp(child: _DelayedWidget()),
      );

      // "Done" doesn't exist yet.
      expect(find.text('Done'), findsNothing);

      await tester.expectThatEventually(
        find.text('Done'),
        matchers: [toBeVisible()],
        timeout: const Duration(seconds: 2),
      );
    });

    testWidgets('throws on timeout', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: SizedBox()),
      );

      expect(
        () => tester.expectThatEventually(
          find.text('Never'),
          matchers: [toBeVisible()],
          timeout: const Duration(milliseconds: 200),
        ),
        throwsA(
          isA<TestFailure>().having(
            (e) => e.message,
            'message',
            contains('Timed out'),
          ),
        ),
      );
    });
  });
}

void _noop() {}

/// A stateful widget that initially shows "Loading" and switches to "Done"
/// after a short delay (simulated via a post-frame callback).
class _DelayedWidget extends StatefulWidget {
  const _DelayedWidget();

  @override
  State<_DelayedWidget> createState() => _DelayedWidgetState();
}

class _DelayedWidgetState extends State<_DelayedWidget> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _done = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_done ? 'Done' : 'Loading');
  }
}

