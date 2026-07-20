import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';
import 'package:widget_test_kit_example/main.dart';

void main() {
  testWidgets('login form submits and shows a welcome message', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(const TestApp(child: LoginForm()));

      await tester.completeForm({
        'email': 'user@example.com',
        'password': 'password123',
      });

      await tester.submitForm(find.button('Login'), expectLoading: true);

      tester.expectThat(find.text('Welcome'), matchers: [toBeVisible()]);
    });
  });

  testWidgets('login screen meets baseline accessibility guidelines', (
    tester,
  ) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(const TestApp(child: LoginForm()));
      await tester.expectMeetsAccessibilityGuidelines();
    });
  });

  testWidgets('login flow via the ScreenRobot pattern', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(const TestApp(child: LoginForm()));

      final robot = LoginRobot(tester);
      await robot.login('user@example.com', 'password123');
      robot.expectWelcome();
    });
  });
}

/// A [ScreenRobot] encapsulating interactions with [LoginForm].
class LoginRobot extends ScreenRobot {
  /// Creates a robot bound to [tester].
  LoginRobot(super.tester);

  /// Finder for the email field.
  Finder get emailField => find.byKey(const Key('email'));

  /// Finder for the password field.
  Finder get passwordField => find.byKey(const Key('password'));

  /// Finder for the login button.
  Finder get loginButton => find.button('Login');

  /// Fills in the form and taps login.
  Future<void> login(String email, String password) async {
    await enterTextIn(emailField, email);
    await enterTextIn(passwordField, password);
    await tapOn(loginButton);
    await waitForAnimations();
  }

  /// Asserts the welcome message is visible.
  void expectWelcome() {
    verify(find.text('Welcome'), matchers: [toBeVisible()]);
  }
}
