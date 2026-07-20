# widget_test_kit

[![pub package](https://img.shields.io/pub/v/widget_test_kit.svg)](https://pub.dev/packages/widget_test_kit)
[![CI](https://github.com/KareemMuhammad/widget_test_kit/actions/workflows/ci.yml/badge.svg)](https://github.com/KareemMuhammad/widget_test_kit/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Declarative, readable widget-testing helpers for Flutter.

Replace verbose, repetitive widget-test boilerplate with a high-level API that reads like a specification.

## Before

```dart
testWidgets('login form submits correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: LoginForm())),
  );

  final emailField = find.byKey(const Key('email'));
  await tester.enterText(emailField, 'user@example.com');

  final passwordField = find.byKey(const Key('password'));
  await tester.enterText(passwordField, 'password123');

  final submitButton = find.widgetWithText(ElevatedButton, 'Login');
  await tester.tap(submitButton);
  await tester.pump();

  expect(find.text('Welcome'), findsOneWidget);
});
```

## After

```dart
testWidgets('login form submits correctly', (tester) async {
  await tester.pumpWidget(TestApp(child: LoginForm()));

  await tester.completeForm({
    'email': 'user@example.com',
    'password': 'password123',
  });

  await tester.submitForm(find.button('Login'));

  tester.expectThat(
    find.text('Welcome'),
    matchers: [toBeVisible()],
  );
});
```

## Installation

Add the package to your `dev_dependencies`:

```yaml
dev_dependencies:
  widget_test_kit: ^0.3.0
```

Then import:

```dart
import 'package:widget_test_kit/widget_test_kit.dart';
```

## API Overview

### TestApp – Simplified Setup

Wraps your widget in `MaterialApp` + `Scaffold` so you don't have to:

```dart
await tester.pumpWidget(
  TestApp(
    child: MyWidget(),
    theme: ThemeData.dark(),          // optional
    locale: const Locale('en', 'US'), // optional
  ),
);
```

Need to inject `ProviderScope`, `BlocProvider`, or other ancestor state without this package depending on any state-management library? Use `wrapper`:

```dart
await tester.pumpWidget(
  TestApp(
    wrapper: (app) => ProviderScope(child: app),
    child: MyWidget(),
  ),
);
```

### Expectation Extensions

#### `expectThat` — multiple matchers at once

```dart
tester.expectThat(
  find.byType(ElevatedButton),
  matchers: [toBeVisible(), toBeEnabled(), toHaveText('Submit')],
);
```

#### `shouldBe` — terse single-matcher alias

```dart
tester.shouldBe(find.byType(Spinner), toNotExist());
```

#### `expectThatEventually` — poll until matchers pass or timeout

```dart
await tester.expectThatEventually(
  find.text('Done'),
  matchers: [toBeVisible()],
  timeout: const Duration(seconds: 3),
);
```

#### `not()` — negate any matcher

```dart
tester.expectThat(
  find.byType(ElevatedButton),
  matchers: [not(toBeDisabled())],
);
```

### Form Extensions

```dart
// Fill a form by widget Keys
await tester.completeForm({
  'email': 'user@example.com',
  'password': 'secret123',
});

// Update existing fields (clear-then-enter strategy)
await tester.updateForm({'email': 'new@example.com'});

// Submit with optional loading-indicator verification
await tester.submitForm(
  find.button('Register'),
  expectLoading: true,
);

// Clear specific fields
await tester.clearForm(['email', 'password']);
```

Custom field-finder strategies via `FieldFinders`:

```dart
await tester.completeForm(
  {'Email': 'a@b.com'},
  findField: FieldFinders.byLabel,
);
```

### Navigation Extensions

```dart
// Push a named route
await tester.navigateTo('/settings');

// Pop the current route
await tester.goBack();

// Assert current route
tester.expectRoute('/home');

// Dialog assertions
tester.expectDialog();
tester.expectNoDialog();
await tester.dismissDialog();

// Bottom sheet assertion
tester.expectBottomSheet();

// SnackBar assertion (with optional text check)
tester.expectSnackBar(withText: 'Saved!');
```

### Gesture Extensions

```dart
// Swipe gestures
await tester.swipeLeft(find.byType(Dismissible));
await tester.swipeRight(find.byType(PageView));
await tester.swipeUp(find.byType(BottomSheet));
await tester.swipeDown(find.byType(RefreshIndicator));

// Tap variants
await tester.longPressOn(find.byKey(Key('item')));
await tester.doubleTapOn(find.text('word'));

// Slider manipulation
await tester.dragSliderTo(find.byType(Slider), 0.75);

// Scroll until a widget appears
await tester.scrollUntilFound(find.text('Item 99'));

// Pull to refresh
await tester.pullToRefresh(find.byType(RefreshIndicator));
```

### Golden Test Extensions

```dart
// Full-app screenshot comparison
await tester.expectGolden('login_page');

// With custom screen size
await tester.expectGolden('home_screen', surfaceSize: Size(400, 800));

// With custom golden path
await tester.expectGolden('home_screen', goldenPath: 'screens/home.png');

// Single widget golden
await tester.expectWidgetGolden(find.byKey(Key('avatar')), 'avatar');

// Screen size helpers for consistent goldens
await tester.setScreenSize(width: 375, height: 812); // iPhone X
await tester.resetScreenSize();

// Capture a golden per locale — great for catching RTL/overflow regressions
await tester.expectGoldenForLocales(
  child: LoginForm(),
  name: 'login_form',
  locales: [Locale('en'), Locale('ar')],
);
```

### Network Image Mocking

`Image.network` normally fails or hangs in widget tests since there's no real network access. Wrap the relevant pump/expect calls in `mockNetworkImages` instead of hand-writing an `HttpOverrides` mock:

```dart
await mockNetworkImages(() async {
  await tester.pumpWidget(TestApp(child: ProfileAvatar()));
  await tester.expectGolden('profile_avatar');
});
```

### Accessibility Extensions

Flutter ships built-in accessibility guideline checks, but they require manually managing a `SemanticsHandle`. These extensions wrap them into single-call assertions:

```dart
// Runs tap-target-size, text-contrast, and labeled-tap-target checks together
await tester.expectMeetsAccessibilityGuidelines();

// Or run an individual guideline
await tester.expectMeetsTapTargetGuideline(platform: TargetPlatform.iOS);
await tester.expectMeetsTextContrastGuideline();
await tester.expectMeetsLabeledTapTargetGuideline();
```

### Finder Extensions

```dart
// Buttons (any ButtonStyleButton / IconButton with label)
await tester.tap(find.button('Login'));

// Icons
tester.expectThat(find.iconWidget(Icons.favorite), matchers: [toBeVisible()]);

// Images by asset name
tester.expectThat(find.imageAsset('assets/logo.png'), matchers: [toBeVisible()]);

// ListTile by title
await tester.tap(find.listTile('Settings'));

// Tab by label
await tester.tap(find.tabWithLabel('Profile'));

// Chip by label
await tester.tap(find.chip('Flutter'));

// TextField by hint or label text
await tester.enterText(find.byHintText('Enter email'), 'a@b.com');
await tester.enterText(find.byLabelText('Password'), 'secret');
```

### Matchers

| Category   | Matchers |
|------------|----------|
| Visibility | `toBeVisible()`, `toBeHidden()`, `toNotExist()` |
| State      | `toBeEnabled()`, `toBeDisabled()`, `toBeChecked()`, `toBeUnchecked()`, `toHaveValue(value)` |
| Content    | `toHaveText(text)`, `toContainText(text)`, `toHaveSemantics(label)` |
| Layout     | `toHaveSize(size)`, `toBePositioned(x, y)`, `toBeWithin(parent)` |
| List       | `toHaveItemCount(n)`, `toContainWidget(finder)`, `toBeScrollable()`, `toBeEmptyList()` |
| Style      | `toHaveOpacity(v)`, `toHaveColor(c)`, `toHaveFontSize(s)`, `toHavePadding(p)`, `toHaveDecoration(d)`, `toHaveBorderRadius(r)`, `toHaveAlignment(a)`, `toHaveElevation(e)`, `toHaveBoxShadow(s)`, `toHaveGradient(g)`, `toHaveTextAlign(a)`, `toHaveFontWeight(w)`, `toHaveMaxLines(n)` |
| Combinator | `not(matcher)` — negates any matcher |

### Custom Matchers

Every matcher is just a `typedef WidgetMatcher = void Function(WidgetTester, Finder)`, so writing your own is trivial:

```dart
WidgetMatcher toHaveTooltip(String expected) {
  return (tester, finder) {
    final tooltip = tester.widget<Tooltip>(
      find.ancestor(of: finder, matching: find.byType(Tooltip)),
    );
    expect(tooltip.message, expected);
  };
}
```

### ScreenRobot – Page-Object Pattern

Encapsulate per-screen interactions in a reusable robot class:

```dart
class LoginRobot extends ScreenRobot {
  LoginRobot(super.tester);

  Finder get emailField => find.byKey(const Key('email'));
  Finder get passwordField => find.byKey(const Key('password'));
  Finder get loginButton => find.button('Login');

  Future<void> login(String email, String password) async {
    await enterTextIn(emailField, email);
    await enterTextIn(passwordField, password);
    await tapOn(loginButton);
  }

  void expectWelcome() {
    verify(find.text('Welcome'), matchers: [toBeVisible()]);
  }
}

// Usage in tests:
testWidgets('login flow', (tester) async {
  await tester.pumpWidget(TestApp(child: LoginPage()));
  final robot = LoginRobot(tester);
  await robot.login('user@example.com', 'secret');
  robot.expectWelcome();
});
```

## Example

See [`example/`](example) for a full runnable app and widget tests covering forms, the robot
pattern, network image mocking, and accessibility assertions.

## License

See [LICENSE](LICENSE).
