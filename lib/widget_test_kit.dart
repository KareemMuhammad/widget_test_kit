/// Declarative, readable widget-testing helpers for Flutter.
///
/// ```dart
/// import 'package:widget_test_kit/widget_test_kit.dart';
///
/// testWidgets('login form', (tester) async {
///   await tester.pumpWidget(TestApp(child: LoginForm()));
///
///   await tester.completeForm({
///     'email': 'user@example.com',
///     'password': 'secret',
///   });
///   await tester.submitForm(find.button('Login'));
///
///   tester.expectThat(
///     find.text('Welcome'),
///     matchers: [toBeVisible()],
///   );
/// });
/// ```
library;

// Core
export 'src/test_app.dart';

// Matchers
export 'src/matchers/widget_matcher.dart';
export 'src/matchers/visibility_matchers.dart';
export 'src/matchers/state_matchers.dart';
export 'src/matchers/content_matchers.dart';
export 'src/matchers/layout_matchers.dart';

// Extensions
export 'src/extensions/widget_tester_expect_extensions.dart';
export 'src/extensions/widget_tester_form_extensions.dart';
export 'src/extensions/common_finders_extensions.dart';

// Helpers
export 'src/helpers/field_finders.dart';
