import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_matcher.dart';

/// Asserts that an interactive widget is **enabled**.
///
/// Supported widgets: [ButtonStyleButton] (ElevatedButton, TextButton,
/// OutlinedButton, FilledButton), [IconButton], [TextField], [TextFormField].
///
/// ```dart
/// tester.expectThat(find.byType(ElevatedButton), matchers: [toBeEnabled()]);
/// ```
WidgetMatcher toBeEnabled() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for enabled check.',
    );

    final widget = tester.widget(finder);

    if (widget is ButtonStyleButton) {
      expect(
        widget.onPressed != null || widget.onLongPress != null,
        isTrue,
        reason:
            'Expected ${widget.runtimeType} to be enabled (onPressed or '
            'onLongPress != null), but both are null.',
      );
    } else if (widget is IconButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'Expected IconButton to be enabled (onPressed != null).',
      );
    } else if (widget is TextField) {
      expect(
        widget.enabled,
        isNot(false),
        reason: 'Expected TextField to be enabled, but enabled is false.',
      );
    } else if (widget is FormField) {
      expect(
        widget.enabled,
        isTrue,
        reason:
            'Expected ${widget.runtimeType} to be enabled, but enabled is false.',
      );
    } else {
      fail(
        'toBeEnabled() does not support ${widget.runtimeType}. '
        'Supported: ButtonStyleButton, IconButton, TextField, TextFormField.',
      );
    }
  };
}

/// Asserts that an interactive widget is **disabled**.
///
/// Supported widgets: same as [toBeEnabled].
///
/// ```dart
/// tester.expectThat(find.byKey(Key('submit')), matchers: [toBeDisabled()]);
/// ```
WidgetMatcher toBeDisabled() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for disabled check.',
    );

    final widget = tester.widget(finder);

    if (widget is ButtonStyleButton) {
      expect(
        widget.onPressed == null && widget.onLongPress == null,
        isTrue,
        reason:
            'Expected ${widget.runtimeType} to be disabled, but it has a '
            'non-null onPressed or onLongPress callback.',
      );
    } else if (widget is IconButton) {
      expect(
        widget.onPressed,
        isNull,
        reason: 'Expected IconButton to be disabled (onPressed == null).',
      );
    } else if (widget is TextField) {
      expect(
        widget.enabled,
        isFalse,
        reason: 'Expected TextField to be disabled, but enabled is not false.',
      );
    } else if (widget is FormField) {
      expect(
        widget.enabled,
        isFalse,
        reason:
            'Expected ${widget.runtimeType} to be disabled, but enabled is true.',
      );
    } else {
      fail(
        'toBeDisabled() does not support ${widget.runtimeType}. '
        'Supported: ButtonStyleButton, IconButton, TextField, TextFormField.',
      );
    }
  };
}

/// Asserts that a toggle widget ([Checkbox], [Switch], [CheckboxListTile],
/// [SwitchListTile]) has a **checked / on** value.
///
/// ```dart
/// tester.expectThat(find.byType(Checkbox), matchers: [toBeChecked()]);
/// ```
WidgetMatcher toBeChecked() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for checked check.',
    );

    final widget = tester.widget(finder);

    if (widget is Checkbox) {
      expect(
        widget.value,
        isTrue,
        reason:
            'Expected Checkbox to be checked, but value is ${widget.value}.',
      );
    } else if (widget is Switch) {
      expect(
        widget.value,
        isTrue,
        reason: 'Expected Switch to be on, but value is ${widget.value}.',
      );
    } else if (widget is CheckboxListTile) {
      expect(
        widget.value,
        isTrue,
        reason:
            'Expected CheckboxListTile to be checked, but value is ${widget.value}.',
      );
    } else if (widget is SwitchListTile) {
      expect(
        widget.value,
        isTrue,
        reason:
            'Expected SwitchListTile to be on, but value is ${widget.value}.',
      );
    } else {
      fail(
        'toBeChecked() does not support ${widget.runtimeType}. '
        'Supported: Checkbox, Switch, CheckboxListTile, SwitchListTile.',
      );
    }
  };
}

/// Asserts that a toggle widget is **unchecked / off**.
///
/// ```dart
/// tester.expectThat(find.byType(Checkbox), matchers: [toBeUnchecked()]);
/// ```
WidgetMatcher toBeUnchecked() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for unchecked check.',
    );

    final widget = tester.widget(finder);

    if (widget is Checkbox) {
      expect(
        widget.value,
        isNot(true),
        reason:
            'Expected Checkbox to be unchecked, but value is ${widget.value}.',
      );
    } else if (widget is Switch) {
      expect(
        widget.value,
        isFalse,
        reason: 'Expected Switch to be off, but value is ${widget.value}.',
      );
    } else if (widget is CheckboxListTile) {
      expect(
        widget.value,
        isNot(true),
        reason:
            'Expected CheckboxListTile to be unchecked, but value is ${widget.value}.',
      );
    } else if (widget is SwitchListTile) {
      expect(
        widget.value,
        isFalse,
        reason:
            'Expected SwitchListTile to be off, but value is ${widget.value}.',
      );
    } else {
      fail(
        'toBeUnchecked() does not support ${widget.runtimeType}. '
        'Supported: Checkbox, Switch, CheckboxListTile, SwitchListTile.',
      );
    }
  };
}

/// Asserts that a text input widget contains [expected] as its current value.
///
/// Works by locating the descendant [EditableText] and reading its controller,
/// which is reliable for both [TextField] and [TextFormField].
///
/// ```dart
/// tester.expectThat(find.byKey(Key('email')), matchers: [toHaveValue('user@example.com')]);
/// ```
WidgetMatcher toHaveValue(dynamic expected) {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for value check.',
    );

    final actual = _readFieldValue(tester, finder);

    expect(
      actual,
      equals(expected.toString()),
      reason: 'Expected field value "$expected" but found "$actual".',
    );
  };
}

/// Reads the current text from a text-input widget by finding its inner
/// [EditableText].
String? _readFieldValue(WidgetTester tester, Finder finder) {
  // The most reliable approach: every TextField / TextFormField contains an
  // EditableText whose controller holds the current text.
  final editableFinder = find.descendant(
    of: finder,
    matching: find.byType(EditableText),
  );

  if (editableFinder.evaluate().isNotEmpty) {
    return tester.widget<EditableText>(editableFinder.first).controller.text;
  }

  // Fallback: the finder itself might point directly at an EditableText.
  final widget = tester.widget(finder);
  if (widget is EditableText) {
    return widget.controller.text;
  }

  fail(
    'toHaveValue() requires a text-input widget (TextField, TextFormField, '
    'or EditableText), but found ${widget.runtimeType}.',
  );
}
