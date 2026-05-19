import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' as testing;
import 'package:flutter_test/flutter_test.dart';

import '../extensions/widget_tester_expect_extensions.dart';
import '../matchers/widget_matcher.dart';

/// A base class for the **Robot / Page-Object** pattern in widget tests.
///
/// Subclass [ScreenRobot] per screen to encapsulate interactions and
/// assertions, making tests read like user stories.
///
/// ```dart
/// class LoginRobot extends ScreenRobot {
///   LoginRobot(super.tester);
///
///   Finder get emailField => find.byKey(const Key('email'));
///   Finder get passwordField => find.byKey(const Key('password'));
///   Finder get loginButton => find.button('Login');
///
///   Future<void> login(String email, String password) async {
///     await enterTextIn(emailField, email);
///     await enterTextIn(passwordField, password);
///     await tapOn(loginButton);
///   }
///
///   void expectWelcome() {
///     verify(find.text('Welcome'), matchers: [toBeVisible()]);
///   }
/// }
///
/// // In a test:
/// testWidgets('login flow', (tester) async {
///   await tester.pumpWidget(TestApp(child: LoginPage()));
///   final robot = LoginRobot(tester);
///   await robot.login('user@example.com', 'secret');
///   robot.expectWelcome();
/// });
/// ```
abstract class ScreenRobot {
  /// The [WidgetTester] instance used for interactions.
  final WidgetTester tester;

  /// Creates a robot bound to the given [tester].
  ScreenRobot(this.tester);

  /// Shortcut to the global [CommonFinders] instance.
  CommonFinders get find => testing.find;

  // ---------------------------------------------------------------------------
  // Interactions
  // ---------------------------------------------------------------------------

  /// Taps the widget found by [finder] and pumps.
  Future<void> tapOn(Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Enters [text] into the field found by [finder] and pumps.
  Future<void> enterTextIn(Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Scrolls until [finder] becomes visible.
  Future<void> scrollTo(Finder finder, {double delta = 100}) async {
    final scrollable = find.byType(Scrollable).first;
    for (var i = 0; i < 50; i++) {
      if (finder.evaluate().isNotEmpty) return;
      await tester.drag(scrollable, Offset(0, -delta));
      await tester.pump();
    }
  }

  /// Waits for animations to complete.
  Future<void> waitForAnimations() async {
    await tester.pumpAndSettle();
  }

  // ---------------------------------------------------------------------------
  // Assertions
  // ---------------------------------------------------------------------------

  /// Asserts that [finder] satisfies all [matchers].
  void verify(Finder finder, {required List<WidgetMatcher> matchers}) {
    tester.expectThat(finder, matchers: matchers);
  }

  /// Polls until [finder] satisfies all [matchers] or times out.
  Future<void> verifyEventually(
    Finder finder, {
    required List<WidgetMatcher> matchers,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.expectThatEventually(
      finder,
      matchers: matchers,
      timeout: timeout,
    );
  }
}
