import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'widget_matcher.dart';

/// Asserts that the widget has the given [expected] size.
///
/// Uses [WidgetTester.getSize] under the hood.
///
/// ```dart
/// tester.expectThat(
///   find.byKey(Key('avatar')),
///   matchers: [toHaveSize(const Size(48, 48))],
/// );
/// ```
WidgetMatcher toHaveSize(Size expected) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for size check.');

    final actual = tester.getSize(finder);

    expect(
      actual,
      equals(expected),
      reason: 'Expected size $expected but found $actual.',
    );
  };
}

/// Asserts that the widget's top-left corner is at position ([x], [y]).
///
/// Uses [WidgetTester.getTopLeft] under the hood.
///
/// ```dart
/// tester.expectThat(
///   find.byKey(Key('fab')),
///   matchers: [toBePositioned(16.0, 16.0)],
/// );
/// ```
WidgetMatcher toBePositioned(double x, double y) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for position check.');

    final actual = tester.getTopLeft(finder);
    final expected = Offset(x, y);

    expect(
      actual,
      equals(expected),
      reason: 'Expected position $expected but found $actual.',
    );
  };
}

/// Asserts that the widget is a descendant of [parent].
///
/// ```dart
/// tester.expectThat(
///   find.text('Save'),
///   matchers: [toBeWithin(find.byType(AppBar))],
/// );
/// ```
WidgetMatcher toBeWithin(Finder parent) {
  return (WidgetTester tester, Finder finder) {
    final descendantFinder = find.descendant(
      of: parent,
      matching: finder,
    );

    expect(
      descendantFinder,
      findsOneWidget,
      reason:
          'Expected widget to be a descendant of the given parent, '
          'but it was not found inside it.',
    );
  };
}

