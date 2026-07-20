// This file verifies that the barrel export works and all public symbols
// are reachable from a single import.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  testWidgets('smoke test – package imports and TestApp renders', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(child: Text('widget_test_kit works!')),
    );

    tester.expectThat(
      find.text('widget_test_kit works!'),
      matchers: [toBeVisible()],
    );
  });
}
