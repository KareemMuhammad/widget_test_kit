# widget_test_helper

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
  widget_test_helper:
    path: ../widget_test_helper  # or from pub once published
```

Then import:

```dart
import 'package:widget_test_helper/widget_test_helper.dart';
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

### Finder Extensions

```dart
// Finds any ElevatedButton, TextButton, OutlinedButton, FilledButton,
// or IconButton that contains a Text descendant with the given label.
await tester.tap(find.button('Login'));
```

### Matchers

| Category   | Matchers |
|------------|----------|
| Visibility | `toBeVisible()`, `toBeHidden()`, `toNotExist()` |
| State      | `toBeEnabled()`, `toBeDisabled()`, `toBeChecked()`, `toBeUnchecked()`, `toHaveValue(value)` |
| Content    | `toHaveText(text)`, `toContainText(text)`, `toHaveSemantics(label)` |
| Layout     | `toHaveSize(size)`, `toBePositioned(x, y)`, `toBeWithin(parent)` |

### Custom Matchers

Every matcher is just a `typedef WidgetMatcher = void Function(WidgetTester, Finder)`, so writing your own is trivial:

```dart
WidgetMatcher toHaveOpacity(double expected) {
  return (tester, finder) {
    final widget = tester.widget<Opacity>(
      find.ancestor(of: finder, matching: find.byType(Opacity)),
    );
    expect(widget.opacity, expected);
  };
}
```

## License

See [LICENSE](LICENSE).
