import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/visibility_matchers.dart';
import 'widget_tester_expect_extensions.dart';

/// Extensions on [WidgetTester] for declarative form interaction.
///
/// ```dart
/// await tester.completeForm({
///   'email': 'user@example.com',
///   'password': 'secret123',
/// });
/// await tester.submitForm(find.button('Register'));
/// ```
extension WidgetTesterFormExtensions on WidgetTester {
  // ---------------------------------------------------------------------------
  // Form completion
  // ---------------------------------------------------------------------------

  /// Fills every field in [values] using the **clear-then-enter** strategy.
  ///
  /// Keys are resolved to finders via [findField]. When [findField] is `null`
  /// (the default), each key is treated as a widget [Key] name.
  ///
  /// ```dart
  /// await tester.completeForm({
  ///   'email': 'user@example.com',
  ///   'password': 'secret',
  /// });
  /// ```
  Future<void> completeForm(
    Map<String, dynamic> values, {
    Finder Function(String key)? findField,
  }) async {
    for (final entry in values.entries) {
      await updateField(
        entry.key,
        entry.value.toString(),
        findField: findField,
      );
    }
  }

  /// Clears the current text of the field identified by [key] and enters
  /// [value].
  ///
  /// Uses the simple **clear-then-enter** strategy:
  /// 1. Tap the field (triggers focus / `onTap`).
  /// 2. `enterText('')` — clears the field, fires `onChanged`.
  /// 3. `enterText(value)` — types the new text, fires `onChanged`.
  /// 4. `pump()` — lets the framework rebuild.
  Future<void> updateField(
    String key,
    String value, {
    Finder Function(String key)? findField,
  }) async {
    final fieldFinder = findField?.call(key) ?? find.byKey(Key(key));

    await tap(fieldFinder);
    await enterText(fieldFinder, ''); // clear
    await enterText(fieldFinder, value); // type new value
    await pump();
  }

  /// Convenience alias for [completeForm] with `String` values – semantically
  /// clearer when you are *modifying* a form that was already filled.
  ///
  /// ```dart
  /// await tester.updateForm({'email': 'new@example.com'});
  /// ```
  Future<void> updateForm(Map<String, String> updates) async {
    for (final entry in updates.entries) {
      await updateField(entry.key, entry.value);
    }
  }

  // ---------------------------------------------------------------------------
  // Form submission
  // ---------------------------------------------------------------------------

  /// Taps [submitButton] and pumps. When [expectLoading] is `true` it also
  /// verifies that a [CircularProgressIndicator] appears and then disappears.
  ///
  /// ```dart
  /// await tester.submitForm(
  ///   find.button('Register'),
  ///   expectLoading: true,
  /// );
  /// ```
  Future<void> submitForm(
    Finder submitButton, {
    bool expectLoading = false,
    Duration loadingTimeout = const Duration(seconds: 5),
  }) async {
    await tap(submitButton);
    await pump();

    if (expectLoading) {
      final loadingFinder = find.byType(CircularProgressIndicator);

      // Wait for the loading indicator to appear …
      await expectThatEventually(
        loadingFinder,
        matchers: [toBeVisible()],
        timeout: loadingTimeout,
      );

      // … then wait for it to go away.
      await expectThatEventually(
        loadingFinder,
        matchers: [toNotExist()],
        timeout: loadingTimeout,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Retry helpers
  // ---------------------------------------------------------------------------

  /// Same as [updateField] but retries up to [retries] times, verifying the
  /// field actually holds [value] after each attempt.
  ///
  /// Useful for flaky CI environments where text-input simulation can
  /// occasionally miss a character.
  Future<void> updateFieldWithRetry(
    String key,
    String value, {
    int retries = 3,
    Finder Function(String key)? findField,
  }) async {
    for (var i = 0; i < retries; i++) {
      try {
        await updateField(key, value, findField: findField);

        // Verify the update stuck.
        final fieldFinder = findField?.call(key) ?? find.byKey(Key(key));
        final current = _readFieldValue(fieldFinder);

        if (current == value) return;
      } catch (_) {
        if (i == retries - 1) rethrow;
        await pump(const Duration(milliseconds: 100));
      }
    }
  }

  /// Clears every field identified by [fieldKeys].
  ///
  /// ```dart
  /// await tester.clearForm(['email', 'password']);
  /// ```
  Future<void> clearForm(List<String> fieldKeys) async {
    for (final key in fieldKeys) {
      await updateField(key, '');
    }
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Reads the current text of a text-input widget by finding its inner
  /// [EditableText].
  String? _readFieldValue(Finder finder) {
    final editableFinder = find.descendant(
      of: finder,
      matching: find.byType(EditableText),
    );

    if (editableFinder.evaluate().isNotEmpty) {
      return widget<EditableText>(editableFinder.first).controller.text;
    }

    final w = widget(finder);
    if (w is EditableText) return w.controller.text;

    return null;
  }
}

