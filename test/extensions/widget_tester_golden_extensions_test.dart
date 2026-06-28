import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('screen size helpers', () {
    testWidgets('setScreenSize and resetScreenSize update the test surface', (
      tester,
    ) async {
      await tester.pumpWidget(const TestApp(child: SizedBox.expand()));

      final defaultSize = tester.getSize(find.byType(MaterialApp));

      await tester.setScreenSize(width: 320, height: 480);
      expect(tester.getSize(find.byType(MaterialApp)), const Size(320, 480));

      await tester.resetScreenSize();
      expect(tester.getSize(find.byType(MaterialApp)), defaultSize);
    });
  });

  group('expectGolden()', () {
    testWidgets('resets custom surface size when comparison fails', (
      tester,
    ) async {
      await tester.pumpWidget(const TestApp(child: SizedBox.expand()));
      final defaultSize = tester.getSize(find.byType(MaterialApp));

      Object? error;
      try {
        await tester.expectGolden(
          'missing_golden',
          surfaceSize: const Size(320, 480),
          goldenPath: 'goldens/does_not_exist.png',
        );
      } catch (e) {
        error = e;
      }

      expect(error, isA<TestFailure>());

      expect(tester.getSize(find.byType(MaterialApp)), defaultSize);
    });
  });
}
