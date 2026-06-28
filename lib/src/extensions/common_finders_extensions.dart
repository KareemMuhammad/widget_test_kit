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

  /// Finds an [Icon] widget with the given [iconData].
  ///
  /// ```dart
  /// tester.tap(find.iconWidget(Icons.delete));
  /// ```
  Finder iconWidget(IconData iconData) {
    return byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == iconData,
    );
  }

  /// Finds an [Image] widget whose image is an [AssetImage] with the given
  /// [assetName].
  ///
  /// ```dart
  /// tester.expectThat(find.imageAsset('assets/logo.png'), matchers: [toBeVisible()]);
  /// ```
  Finder imageAsset(String assetName) {
    return byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == assetName,
    );
  }

  /// Finds a [ListTile] whose title contains the given [title] text.
  ///
  /// ```dart
  /// await tester.tap(find.listTile('Settings'));
  /// ```
  Finder listTile(String title) {
    return ancestor(of: text(title), matching: byType(ListTile));
  }

  /// Finds a [Tab] widget with the given [label].
  ///
  /// ```dart
  /// await tester.tap(find.tabWithLabel('Profile'));
  /// ```
  Finder tabWithLabel(String label) {
    return ancestor(of: text(label), matching: byType(Tab));
  }

  /// Finds a [DropdownButton] (or [DropdownButtonFormField]) that contains
  /// a [Text] descendant with [label].
  ///
  /// ```dart
  /// await tester.tap(find.dropdown('Country'));
  /// ```
  Finder dropdown(String label) {
    return ancestor(
      of: text(label),
      matching: byWidgetPredicate(
        (widget) =>
            widget is DropdownButton || widget is DropdownButtonFormField,
      ),
    );
  }

  /// Finds a [Chip], [InputChip], [FilterChip], [ActionChip], or [ChoiceChip]
  /// whose label text equals [label].
  ///
  /// ```dart
  /// await tester.tap(find.chip('Flutter'));
  /// ```
  Finder chip(String label) {
    return ancestor(
      of: text(label),
      matching: byWidgetPredicate(
        (widget) =>
            widget is Chip ||
            widget is InputChip ||
            widget is FilterChip ||
            widget is ActionChip ||
            widget is ChoiceChip,
      ),
    );
  }

  /// Finds a [TextField] or [TextFormField] by its hint text.
  ///
  /// ```dart
  /// await tester.enterText(find.byHintText('Enter email'), 'a@b.com');
  /// ```
  Finder byHintText(String hint) {
    return ancestor(of: text(hint), matching: byType(TextField));
  }

  /// Finds a [TextField] or [TextFormField] by its label text.
  ///
  /// ```dart
  /// await tester.enterText(find.byLabelText('Email'), 'a@b.com');
  /// ```
  Finder byLabelText(String label) {
    return ancestor(of: text(label), matching: byType(TextField));
  }
}
