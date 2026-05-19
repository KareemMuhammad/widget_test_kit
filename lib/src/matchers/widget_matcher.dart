import 'package:flutter_test/flutter_test.dart';

/// Core typedef for widget matchers.
///
/// A [WidgetMatcher] is a function that asserts a condition about a widget
/// found by [finder] using the provided [tester]. It throws [TestFailure]
/// if the assertion fails.
///
/// ```dart
/// WidgetMatcher myMatcher() {
///   return (tester, finder) {
///     expect(finder, findsOneWidget);
///   };
/// }
/// ```
typedef WidgetMatcher = void Function(WidgetTester tester, Finder finder);

/// Convenience helper to combine multiple matcher lists into one.
///
/// ```dart
/// final matchers = allMatchers([
///   toBeVisible(),
///   toBeEnabled(),
///   toHaveText('Submit'),
/// ]);
/// ```
List<WidgetMatcher> allMatchers(List<WidgetMatcher> matchers) => matchers;

/// Negates a [WidgetMatcher]. Passes when the inner matcher **fails**.
///
/// ```dart
/// tester.expectThat(
///   find.byType(Spinner),
///   matchers: [not(toBeVisible())],
/// );
/// ```
WidgetMatcher not(WidgetMatcher matcher) {
  return (WidgetTester tester, Finder finder) {
    bool passed = false;
    try {
      matcher(tester, finder);
      passed = true;
    } on TestFailure {
      // Expected: the inner matcher should fail.
      return;
    }
    if (passed) {
      throw TestFailure(
        'Expected matcher to fail, but it passed. '
        'Use not() only to negate a matcher that would otherwise succeed.',
      );
    }
  };
}
