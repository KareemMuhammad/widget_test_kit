import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_matcher.dart';

/// Asserts that the widget (or its ancestor [Opacity]/[FadeTransition]) has
/// the given [expected] opacity value.
///
/// ```dart
/// tester.expectThat(find.byKey(Key('card')), matchers: [toHaveOpacity(0.5)]);
/// ```
WidgetMatcher toHaveOpacity(double expected) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for opacity check.');

    // Check if the widget itself is an Opacity widget.
    final widget = tester.widget(finder);
    if (widget is Opacity) {
      expect(widget.opacity, moreOrLessEquals(expected),
          reason: 'Expected opacity $expected but found ${widget.opacity}.');
      return;
    }

    // Check for an Opacity ancestor.
    final opacityFinder = find.ancestor(
      of: finder,
      matching: find.byType(Opacity),
    );

    if (opacityFinder.evaluate().isNotEmpty) {
      final opacity = tester.widget<Opacity>(opacityFinder.first);
      expect(opacity.opacity, moreOrLessEquals(expected),
          reason: 'Expected opacity $expected but found ${opacity.opacity}.');
      return;
    }

    // Check for FadeTransition ancestor.
    final fadeFinder = find.ancestor(
      of: finder,
      matching: find.byType(FadeTransition),
    );

    if (fadeFinder.evaluate().isNotEmpty) {
      final fade = tester.widget<FadeTransition>(fadeFinder.first);
      expect(fade.opacity.value, moreOrLessEquals(expected),
          reason:
              'Expected opacity $expected but found ${fade.opacity.value}.');
      return;
    }

    fail('toHaveOpacity() could not find an Opacity or FadeTransition '
        'for ${widget.runtimeType}.');
  };
}

/// Asserts the widget has the given [expected] color.
///
/// Supports [Icon], [Text] (via style), [Container] (via BoxDecoration),
/// and [ColoredBox].
///
/// ```dart
/// tester.expectThat(find.byType(Icon), matchers: [toHaveColor(Colors.red)]);
/// ```
WidgetMatcher toHaveColor(Color expected) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for color check.');

    final widget = tester.widget(finder);

    if (widget is Icon) {
      expect(widget.color, equals(expected),
          reason: 'Expected Icon color $expected but found ${widget.color}.');
    } else if (widget is Text) {
      expect(widget.style?.color, equals(expected),
          reason:
              'Expected Text color $expected but found ${widget.style?.color}.');
    } else if (widget is Container) {
      final decoration = widget.decoration;
      if (decoration is BoxDecoration) {
        expect(decoration.color, equals(expected),
            reason:
                'Expected Container color $expected but found ${decoration.color}.');
      } else {
        expect(widget.color, equals(expected),
            reason:
                'Expected Container color $expected but found ${widget.color}.');
      }
    } else if (widget is ColoredBox) {
      expect(widget.color, equals(expected),
          reason:
              'Expected ColoredBox color $expected but found ${widget.color}.');
    } else {
      fail('toHaveColor() does not support ${widget.runtimeType}. '
          'Supported: Icon, Text, Container, ColoredBox.');
    }
  };
}

/// Asserts that a [Text] widget has the given [expected] font size.
///
/// ```dart
/// tester.expectThat(find.text('Title'), matchers: [toHaveFontSize(24)]);
/// ```
WidgetMatcher toHaveFontSize(double expected) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for font size check.');

    final widget = tester.widget(finder);

    if (widget is Text) {
      expect(widget.style?.fontSize, equals(expected),
          reason:
              'Expected fontSize $expected but found ${widget.style?.fontSize}.');
    } else {
      fail('toHaveFontSize() requires a Text widget, '
          'but found ${widget.runtimeType}.');
    }
  };
}

/// Asserts the widget has the given [expected] padding.
///
/// Works with [Padding] widgets directly or as a descendant/ancestor.
///
/// ```dart
/// tester.expectThat(
///   find.byKey(Key('card')),
///   matchers: [toHavePadding(EdgeInsets.all(16))],
/// );
/// ```
WidgetMatcher toHavePadding(EdgeInsetsGeometry expected) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for padding check.');

    final widget = tester.widget(finder);

    if (widget is Padding) {
      expect(widget.padding, equals(expected),
          reason:
              'Expected padding $expected but found ${widget.padding}.');
      return;
    }

    if (widget is Container) {
      expect(widget.padding, equals(expected),
          reason:
              'Expected padding $expected but found ${widget.padding}.');
      return;
    }

    // Look for a Padding ancestor.
    final paddingFinder = find.ancestor(
      of: finder,
      matching: find.byType(Padding),
    );

    if (paddingFinder.evaluate().isNotEmpty) {
      final padding = tester.widget<Padding>(paddingFinder.first);
      expect(padding.padding, equals(expected),
          reason:
              'Expected padding $expected but found ${padding.padding}.');
      return;
    }

    fail('toHavePadding() could not find a Padding widget for '
        '${widget.runtimeType}.');
  };
}

/// Asserts a [Container] or [DecoratedBox] has the given [BoxDecoration].
///
/// ```dart
/// tester.expectThat(
///   find.byKey(Key('box')),
///   matchers: [toHaveDecoration(BoxDecoration(color: Colors.blue))],
/// );
/// ```
WidgetMatcher toHaveDecoration(BoxDecoration expected) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for decoration check.');

    final widget = tester.widget(finder);

    if (widget is Container) {
      expect(widget.decoration, equals(expected),
          reason: 'Expected decoration $expected but found ${widget.decoration}.');
    } else if (widget is DecoratedBox) {
      expect(widget.decoration, equals(expected),
          reason: 'Expected decoration $expected but found ${widget.decoration}.');
    } else {
      fail('toHaveDecoration() requires a Container or DecoratedBox, '
          'but found ${widget.runtimeType}.');
    }
  };
}

/// Asserts the widget has the given [expected] border radius.
///
/// Works with [Container] (via BoxDecoration), [ClipRRect], and [Material].
///
/// ```dart
/// tester.expectThat(
///   find.byKey(Key('card')),
///   matchers: [toHaveBorderRadius(BorderRadius.circular(8))],
/// );
/// ```
WidgetMatcher toHaveBorderRadius(BorderRadius expected) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for border radius check.');

    final widget = tester.widget(finder);

    if (widget is ClipRRect) {
      expect(widget.borderRadius, equals(expected),
          reason:
              'Expected borderRadius $expected but found ${widget.borderRadius}.');
    } else if (widget is Container) {
      final decoration = widget.decoration;
      if (decoration is BoxDecoration) {
        expect(decoration.borderRadius, equals(expected),
            reason:
                'Expected borderRadius $expected but found ${decoration.borderRadius}.');
      } else {
        fail('toHaveBorderRadius() requires a Container with BoxDecoration.');
      }
    } else if (widget is Material) {
      final shape = widget.borderRadius;
      expect(shape, equals(expected),
          reason: 'Expected borderRadius $expected but found $shape.');
    } else {
      fail('toHaveBorderRadius() does not support ${widget.runtimeType}. '
          'Supported: ClipRRect, Container (with BoxDecoration), Material.');
    }
  };
}

/// Asserts the widget has the given [expected] alignment.
///
/// Works with [Align] and [Container].
///
/// ```dart
/// tester.expectThat(
///   find.byKey(Key('centered')),
///   matchers: [toHaveAlignment(Alignment.center)],
/// );
/// ```
WidgetMatcher toHaveAlignment(AlignmentGeometry expected) {
  return (WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget,
        reason: 'Expected widget to exist for alignment check.');

    final widget = tester.widget(finder);

    if (widget is Align) {
      expect(widget.alignment, equals(expected),
          reason:
              'Expected alignment $expected but found ${widget.alignment}.');
    } else if (widget is Container) {
      expect(widget.alignment, equals(expected),
          reason:
              'Expected alignment $expected but found ${widget.alignment}.');
    } else {
      fail('toHaveAlignment() does not support ${widget.runtimeType}. '
          'Supported: Align, Container.');
    }
  };
}
