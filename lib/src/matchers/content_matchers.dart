import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_matcher.dart';

/// Asserts that the widget (or a descendant) contains a [Text] widget whose
/// `data` equals [expected] exactly.
///
/// If the finder itself points at a [Text] widget, its `data` is compared
/// directly.
///
/// ```dart
/// tester.expectThat(find.byType(Card), matchers: [toHaveText('Title')]);
/// ```
WidgetMatcher toHaveText(String expected) {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for text check.',
    );

    final widget = tester.widget(finder);

    if (widget is Text) {
      final actual = widget.data ?? widget.textSpan?.toPlainText();
      expect(
        actual,
        equals(expected),
        reason: 'Expected text "$expected" but found "$actual".',
      );
      return;
    }

    // Search descendants for an exact-match Text widget.
    final textFinder = find.descendant(
      of: finder,
      matching: find.text(expected),
    );

    expect(
      textFinder,
      findsWidgets,
      reason:
          'Expected widget to contain text "$expected", but no matching Text '
          'widget was found among its descendants.',
    );
  };
}

/// Asserts that the widget (or a descendant) contains a [Text] widget whose
/// `data` includes [substring].
///
/// ```dart
/// tester.expectThat(find.byType(Card), matchers: [toContainText('ello')]);
/// ```
WidgetMatcher toContainText(String substring) {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for text check.',
    );

    final widget = tester.widget(finder);

    if (widget is Text) {
      final actual = widget.data ?? widget.textSpan?.toPlainText() ?? '';
      expect(
        actual.contains(substring),
        isTrue,
        reason: 'Expected text to contain "$substring" but found "$actual".',
      );
      return;
    }

    // Walk descendants looking for any Text that contains the substring.
    final element = tester.element(finder);
    bool found = false;

    void visit(Element el) {
      if (found) return;
      if (el.widget is Text) {
        final text = el.widget as Text;
        final data = text.data ?? text.textSpan?.toPlainText() ?? '';
        if (data.contains(substring)) {
          found = true;
          return;
        }
      }
      el.visitChildElements(visit);
    }

    element.visitChildElements(visit);

    expect(
      found,
      isTrue,
      reason:
          'Expected widget to contain text including "$substring", but no '
          'matching Text widget was found among its descendants.',
    );
  };
}

/// Asserts that the widget's [SemanticsNode] carries the given [label].
///
/// **Important:** Semantics must be enabled before using this matcher.
/// Call `tester.ensureSemantics()` at the start of your test (and dispose
/// the handle at the end).
///
/// ```dart
/// final handle = tester.ensureSemantics();
/// tester.expectThat(find.byType(IconButton), matchers: [toHaveSemantics('Close')]);
/// handle.dispose();
/// ```
WidgetMatcher toHaveSemantics(String label) {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for semantics check.',
    );

    late final SemanticsNode semantics;
    try {
      semantics = tester.getSemantics(finder);
    } catch (_) {
      fail(
        'Expected widget to have semantics data with label "$label", but '
        'no SemanticsNode was found. Ensure the widget (or an ancestor) '
        'provides Semantics and that tester.ensureSemantics() has been called.',
      );
    }

    expect(
      semantics.label,
      equals(label),
      reason:
          'Expected semantics label "$label" but found "${semantics.label}".',
    );
  };
}
