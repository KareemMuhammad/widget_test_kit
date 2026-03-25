import 'package:flutter_test/flutter_test.dart';

import '../matchers/widget_matcher.dart';

/// Extensions on [WidgetTester] for declarative widget assertions.
///
/// These replace verbose `expect(find…, findsOneWidget)` calls with a
/// readable, composable API.
///
/// ```dart
/// tester.expectThat(
///   find.byType(ElevatedButton),
///   matchers: [toBeVisible(), toBeEnabled(), toHaveText('Submit')],
/// );
/// ```
extension WidgetTesterExpectExtensions on WidgetTester {
  // ---------------------------------------------------------------------------
  // Synchronous assertions
  // ---------------------------------------------------------------------------

  /// Asserts that the widget found by [finder] satisfies every matcher in
  /// [matchers].
  ///
  /// If any matcher throws a [TestFailure], an optional [reason] is prepended
  /// to the failure message for additional context.
  void expectThat(
    Finder finder, {
    required List<WidgetMatcher> matchers,
    String? reason,
  }) {
    _evaluateMatchers(finder, matchers, reason);
  }

  /// Convenience overload when only a single matcher is needed.
  ///
  /// ```dart
  /// tester.expectThatSingle(find.text('Hi'), matcher: toBeVisible());
  /// ```
  void expectThatSingle(
    Finder finder, {
    required WidgetMatcher matcher,
    String? reason,
  }) {
    expectThat(finder, matchers: [matcher], reason: reason);
  }

  /// Terse alias for a single-matcher assertion.
  ///
  /// ```dart
  /// tester.shouldBe(find.byType(Spinner), toNotExist());
  /// ```
  void shouldBe(Finder finder, WidgetMatcher matcher) {
    expectThat(finder, matchers: [matcher]);
  }

  // ---------------------------------------------------------------------------
  // Async / polling assertion
  // ---------------------------------------------------------------------------

  /// Repeatedly evaluates [matchers] against [finder], pumping the widget tree
  /// between attempts, until all matchers pass **or** [timeout] elapses.
  ///
  /// This is the **single place** where timeout / retry logic lives — no
  /// individual matcher needs to worry about time.
  ///
  /// ```dart
  /// await tester.expectThatEventually(
  ///   find.text('Done'),
  ///   matchers: [toBeVisible()],
  ///   timeout: const Duration(seconds: 3),
  /// );
  /// ```
  Future<void> expectThatEventually(
    Finder finder, {
    required List<WidgetMatcher> matchers,
    Duration timeout = const Duration(seconds: 5),
    Duration pollInterval = const Duration(milliseconds: 50),
    String? reason,
  }) async {
    final maxAttempts = timeout.inMilliseconds ~/ pollInterval.inMilliseconds;
    TestFailure? lastFailure;

    for (var i = 0; i <= maxAttempts; i++) {
      try {
        for (final matcher in matchers) {
          matcher(this, finder);
        }
        return; // All matchers passed.
      } on TestFailure catch (e) {
        lastFailure = e;
        if (i < maxAttempts) {
          await pump(pollInterval);
        }
      }
    }

    throw TestFailure(
      'Timed out after $timeout. '
      '${reason ?? lastFailure?.message ?? "Condition not met."}',
    );
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  void _evaluateMatchers(
    Finder finder,
    List<WidgetMatcher> matchers,
    String? reason,
  ) {
    try {
      for (final matcher in matchers) {
        matcher(this, finder);
      }
    } on TestFailure catch (e) {
      if (reason != null) {
        throw TestFailure('$reason\n${e.message}');
      }
      rethrow;
    }
  }
}

