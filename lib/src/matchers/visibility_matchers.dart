import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_matcher.dart';

/// Asserts that the widget is rendered and not obscured by [Offstage] or
/// [Visibility] ancestors.
///
/// ```dart
/// tester.expectThat(find.text('Hello'), matchers: [toBeVisible()]);
/// ```
WidgetMatcher toBeVisible() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason:
          'Expected widget to be visible, but it was not found in the widget tree.',
    );

    final element = tester.element(finder);

    bool isHidden = false;
    String? hiddenBy;

    element.visitAncestorElements((ancestor) {
      final widget = ancestor.widget;
      if (widget is Offstage && widget.offstage) {
        isHidden = true;
        hiddenBy = 'Offstage';
        return false;
      }
      if (widget is Visibility && !widget.visible) {
        isHidden = true;
        hiddenBy = 'Visibility';
        return false;
      }
      if (widget is Opacity && widget.opacity == 0) {
        isHidden = true;
        hiddenBy = 'Opacity(0)';
        return false;
      }
      return true;
    });

    expect(
      isHidden,
      isFalse,
      reason:
          'Expected widget to be visible, but it is hidden by a $hiddenBy widget.',
    );
  };
}

/// Asserts that the widget exists in the tree but is hidden by an [Offstage],
/// [Visibility], or zero-[Opacity] ancestor.
///
/// **Note:** For widgets hidden via [Offstage], the finder must be created
/// with `skipOffstage: false` (e.g. `find.byKey(key, skipOffstage: false)`).
///
/// ```dart
/// tester.expectThat(
///   find.byKey(Key('banner'), skipOffstage: false),
///   matchers: [toBeHidden()],
/// );
/// ```
WidgetMatcher toBeHidden() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason:
          'Expected widget to exist (but be hidden). It was not found at all. '
          'If the widget is inside an Offstage, use a finder with '
          'skipOffstage: false.',
    );

    final element = tester.element(finder);

    bool isHidden = false;

    element.visitAncestorElements((ancestor) {
      final widget = ancestor.widget;
      if (widget is Offstage && widget.offstage) {
        isHidden = true;
        return false;
      }
      if (widget is Visibility && !widget.visible) {
        isHidden = true;
        return false;
      }
      if (widget is Opacity && widget.opacity == 0) {
        isHidden = true;
        return false;
      }
      return true;
    });

    expect(
      isHidden,
      isTrue,
      reason:
          'Expected widget to be hidden (Offstage, Visibility, or Opacity), '
          'but it appears to be visible.',
    );
  };
}

/// Asserts that the finder matches **no** widgets in the tree.
///
/// ```dart
/// tester.expectThat(find.byType(ErrorBanner), matchers: [toNotExist()]);
/// ```
WidgetMatcher toNotExist() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsNothing,
      reason:
          'Expected widget to not exist, but it was found in the widget tree.',
    );
  };
}

