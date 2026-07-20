import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('accessibility extensions', () {
    testWidgets(
      'expectMeetsTapTargetGuideline fails for an undersized tap target',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: Center(
              child: Semantics(
                button: true,
                onTap: () {},
                child: const SizedBox(width: 10, height: 10),
              ),
            ),
          ),
        );

        await expectLater(
          () => tester.expectMeetsTapTargetGuideline(),
          throwsA(isA<TestFailure>()),
        );
      },
    );

    testWidgets(
      'expectMeetsTapTargetGuideline passes for a standard ElevatedButton',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: ElevatedButton(onPressed: () {}, child: const Text('Tap')),
          ),
        );

        await tester.expectMeetsTapTargetGuideline();
      },
    );

    testWidgets(
      'expectMeetsTextContrastGuideline fails for low-contrast text',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: ColoredBox(
              color: Colors.white,
              child: Text('invisible', style: TextStyle(color: Colors.white)),
            ),
          ),
        );

        await expectLater(
          () => tester.expectMeetsTextContrastGuideline(),
          throwsA(isA<TestFailure>()),
        );
      },
    );

    testWidgets('expectMeetsAccessibilityGuidelines runs all checks', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Continue'),
          ),
        ),
      );

      await tester.expectMeetsAccessibilityGuidelines();
    });
  });
}
