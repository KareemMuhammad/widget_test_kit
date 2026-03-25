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

