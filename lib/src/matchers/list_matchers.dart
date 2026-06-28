import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_matcher.dart';

/// Asserts that the widget has exactly [expected] child items rendered.
///
/// Works with [ListView], [GridView], or falls back to counting descendants.
///
/// ```dart
/// tester.expectThat(find.byType(ListView), matchers: [toHaveItemCount(5)]);
/// ```
WidgetMatcher toHaveItemCount(int expected) {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for item count check.',
    );

    final widget = tester.widget(finder);
    int? count;

    if (widget is ListView) {
      count = _countSliverChildren(widget.childrenDelegate);
    } else if (widget is GridView) {
      count = _countSliverChildren(widget.childrenDelegate);
    } else {
      final children = find.descendant(
        of: finder,
        matching: find.byWidgetPredicate((_) => true),
      );
      count = children.evaluate().length;
    }

    if (count == null) {
      fail(
        'toHaveItemCount() cannot determine the item count for '
        '${widget.runtimeType}. Builder-backed lists must provide itemCount.',
      );
    }

    expect(
      count,
      equals(expected),
      reason: 'Expected $expected items but found $count.',
    );
  };
}

/// Asserts that the widget tree under [finder] contains at least one widget
/// matching [childFinder].
///
/// ```dart
/// tester.expectThat(
///   find.byType(ListView),
///   matchers: [toContainWidget(find.text('Item 1'))],
/// );
/// ```
WidgetMatcher toContainWidget(Finder childFinder) {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected parent widget to exist for containment check.',
    );

    final descendant = find.descendant(of: finder, matching: childFinder);
    expect(
      descendant,
      findsWidgets,
      reason:
          'Expected widget to contain a descendant matching the given finder, '
          'but none was found.',
    );
  };
}

/// Asserts that the found widget is scrollable (contains a [Scrollable]).
///
/// ```dart
/// tester.expectThat(find.byType(ListView), matchers: [toBeScrollable()]);
/// ```
WidgetMatcher toBeScrollable() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for scrollable check.',
    );

    final scrollable = find.descendant(
      of: finder,
      matching: find.byType(Scrollable),
    );

    final isScrollableItself =
        tester.widget(finder) is Scrollable || scrollable.evaluate().isNotEmpty;

    expect(
      isScrollableItself,
      isTrue,
      reason: 'Expected widget to be scrollable, but no Scrollable was found.',
    );
  };
}

/// Asserts that the list/container has no visible children (is empty).
///
/// ```dart
/// tester.expectThat(find.byType(ListView), matchers: [toBeEmptyList()]);
/// ```
WidgetMatcher toBeEmptyList() {
  return (WidgetTester tester, Finder finder) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Expected widget to exist for empty check.',
    );

    final widget = tester.widget(finder);
    int? count;

    if (widget is ListView) {
      count = _countSliverChildren(widget.childrenDelegate);
    } else if (widget is GridView) {
      count = _countSliverChildren(widget.childrenDelegate);
    }

    if (count != null) {
      expect(
        count,
        equals(0),
        reason: 'Expected list to be empty but found $count items.',
      );
    } else {
      fail(
        'toBeEmptyList() requires a ListView or GridView, '
        'but found ${widget.runtimeType}.',
      );
    }
  };
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

int? _countSliverChildren(SliverChildDelegate delegate) {
  if (delegate is SliverChildListDelegate) {
    return delegate.children.length;
  } else if (delegate is SliverChildBuilderDelegate) {
    return delegate.estimatedChildCount;
  }
  return null;
}
