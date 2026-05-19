import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
/// Extensions on [WidgetTester] for gesture and interaction helpers.
///
/// ```dart
/// await tester.swipeLeft(find.byType(Dismissible));
/// await tester.longPressOn(find.byKey(Key('item')));
/// await tester.doubleTapOn(find.text('Like'));
/// ```
extension WidgetTesterGestureExtensions on WidgetTester {
  // ---------------------------------------------------------------------------
  // Swipe gestures
  // ---------------------------------------------------------------------------
  /// Flings the widget to the **left** (e.g. dismiss, next page).
  ///
  /// ```dart
  /// await tester.swipeLeft(find.byType(Dismissible));
  /// ```
  Future<void> swipeLeft(Finder finder, {double velocity = 1000}) async {
    await fling(finder, const Offset(-300, 0), velocity);
    await pumpAndSettle();
  }
  /// Flings the widget to the **right**.
  ///
  /// ```dart
  /// await tester.swipeRight(find.byType(Dismissible));
  /// ```
  Future<void> swipeRight(Finder finder, {double velocity = 1000}) async {
    await fling(finder, const Offset(300, 0), velocity);
    await pumpAndSettle();
  }
  /// Flings the widget **up** (e.g. scroll up, dismiss bottom sheet).
  ///
  /// ```dart
  /// await tester.swipeUp(find.byType(ListView));
  /// ```
  Future<void> swipeUp(Finder finder, {double velocity = 1000}) async {
    await fling(finder, const Offset(0, -300), velocity);
    await pumpAndSettle();
  }
  /// Flings the widget **down** (e.g. pull to refresh).
  ///
  /// ```dart
  /// await tester.swipeDown(find.byType(RefreshIndicator));
  /// ```
  Future<void> swipeDown(Finder finder, {double velocity = 1000}) async {
    await fling(finder, const Offset(0, 300), velocity);
    await pumpAndSettle();
  }
  // ---------------------------------------------------------------------------
  // Tap variants
  // ---------------------------------------------------------------------------
  /// Performs a **long press** on [finder] and pumps.
  ///
  /// ```dart
  /// await tester.longPressOn(find.byKey(Key('item')));
  /// ```
  Future<void> longPressOn(Finder finder) async {
    await longPress(finder);
    await pumpAndSettle();
  }
  /// Performs a **double tap** on [finder] and pumps.
  ///
  /// ```dart
  /// await tester.doubleTapOn(find.text('word'));
  /// ```
  Future<void> doubleTapOn(Finder finder) async {
    await tap(finder);
    await pump(const Duration(milliseconds: 50));
    await tap(finder);
    await pumpAndSettle();
  }
  // ---------------------------------------------------------------------------
  // Slider
  // ---------------------------------------------------------------------------
  /// Drags a [Slider] to the given [value] (expected range 0.0-1.0).
  ///
  /// ```dart
  /// await tester.dragSliderTo(find.byType(Slider), 0.75);
  /// ```
  Future<void> dragSliderTo(Finder finder, double value) async {
    expect(finder, findsOneWidget,
        reason: 'Expected a Slider widget to exist for dragSliderTo.');
    final sliderRect = getRect(finder);
    final currentCenter = getCenter(finder);
    final targetX = sliderRect.left + (sliderRect.width * value.clamp(0.0, 1.0));
    final offset = Offset(targetX - currentCenter.dx, 0);
    await drag(finder, offset);
    await pumpAndSettle();
  }
  // ---------------------------------------------------------------------------
  // Scroll helpers
  // ---------------------------------------------------------------------------
  /// Scrolls until [finder] becomes visible.
  ///
  /// ```dart
  /// await tester.scrollUntilFound(find.text('Item 99'));
  /// ```
  Future<void> scrollUntilFound(
    Finder finder, {
    Finder? scrollable,
    double delta = 100,
    int maxScrolls = 50,
  }) async {
    final scrollableFinder = scrollable ?? find.byType(Scrollable).first;
    for (var i = 0; i < maxScrolls; i++) {
      if (finder.evaluate().isNotEmpty) return;
      await drag(scrollableFinder, Offset(0, -delta));
      await pump();
    }
    expect(finder, findsWidgets,
        reason: 'scrollUntilFound: widget not found after $maxScrolls scrolls.');
  }
  // ---------------------------------------------------------------------------
  // Pull to refresh
  // ---------------------------------------------------------------------------
  /// Simulates a **pull-to-refresh** gesture.
  ///
  /// ```dart
  /// await tester.pullToRefresh(find.byType(RefreshIndicator));
  /// ```
  Future<void> pullToRefresh(Finder finder, {double distance = 300}) async {
    await drag(finder, Offset(0, distance));
    await pumpAndSettle();
  }
}
