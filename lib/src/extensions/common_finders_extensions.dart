import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adds convenience finders to the global [find] ([CommonFinders]) object.
extension CommonFindersExtensions on CommonFinders {
  /// Finds any button ([ElevatedButton], [TextButton], [OutlinedButton],
  /// [FilledButton], [IconButton]) that contains a [Text] descendant whose
  /// data equals [label].
  ///
  /// ```dart
  /// await tester.tap(find.button('Login'));
  /// ```
  Finder button(String label) {
    return ancestor(
      of: text(label),
      matching: byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton ||
            widget is TextButton ||
            widget is OutlinedButton ||
            widget is FilledButton ||
            widget is IconButton,
      ),
    );
  }
}

