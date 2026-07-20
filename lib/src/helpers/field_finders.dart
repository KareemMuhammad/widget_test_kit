import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pre-built field-finder strategies for use with [completeForm] and
/// [updateField].
///
/// Each static method returns a [Finder] that locates a single form field.
///
/// ```dart
/// await tester.completeForm(
///   {'email': 'a@b.com'},
///   findField: FieldFinders.byLabel,
/// );
/// ```
class FieldFinders {
  FieldFinders._(); // non-instantiable

  /// Finds a widget whose [Key] name equals [key]. *(default strategy)*
  static Finder byKey(String key) => find.byKey(Key(key));

  /// Finds a [TextFormField] (or [TextField]) that has a [Text] descendant
  /// matching [label] — typically the `decoration.labelText`.
  static Finder byLabel(String label) =>
      find.widgetWithText(TextFormField, label);

  /// Finds a [TextField] whose [InputDecoration.hintText] equals [hint].
  static Finder byHint(String hint) => find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.hintText == hint,
  );

  /// Finds a widget by its accessibility / semantics [label].
  static Finder bySemantics(String label) => find.bySemanticsLabel(label);
}
