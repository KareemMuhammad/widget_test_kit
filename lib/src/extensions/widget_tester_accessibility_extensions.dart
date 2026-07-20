import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extensions on [WidgetTester] for declarative accessibility assertions.
///
/// Wraps Flutter's built-in [AccessibilityGuideline] checks — normally used
/// via a manual [SemanticsHandle] and
/// `await expectLater(tester, meetsGuideline(...))` — into single-call
/// assertions.
///
/// ```dart
/// await tester.expectMeetsAccessibilityGuidelines();
/// ```
extension WidgetTesterAccessibilityExtensions on WidgetTester {
  /// Asserts that every tappable widget in the tree meets the platform's
  /// minimum tap-target size (48x48 on Android, 44x44 on iOS).
  ///
  /// ```dart
  /// await tester.expectMeetsTapTargetGuideline();
  /// await tester.expectMeetsTapTargetGuideline(platform: TargetPlatform.iOS);
  /// ```
  Future<void> expectMeetsTapTargetGuideline({
    TargetPlatform platform = TargetPlatform.android,
  }) async {
    final handle = ensureSemantics();
    try {
      await pump();
      await expectLater(
        this,
        meetsGuideline(
          platform == TargetPlatform.iOS
              ? iOSTapTargetGuideline
              : androidTapTargetGuideline,
        ),
      );
    } finally {
      handle.dispose();
    }
  }

  /// Asserts that text in the tree has sufficient contrast against its
  /// background, per WCAG guidelines.
  ///
  /// ```dart
  /// await tester.expectMeetsTextContrastGuideline();
  /// ```
  Future<void> expectMeetsTextContrastGuideline() async {
    final handle = ensureSemantics();
    try {
      await pump();
      await expectLater(this, meetsGuideline(textContrastGuideline));
    } finally {
      handle.dispose();
    }
  }

  /// Asserts that every tappable widget with a semantic label has a tap
  /// target large enough to comfortably contain that label.
  ///
  /// ```dart
  /// await tester.expectMeetsLabeledTapTargetGuideline();
  /// ```
  Future<void> expectMeetsLabeledTapTargetGuideline() async {
    final handle = ensureSemantics();
    try {
      await pump();
      await expectLater(this, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      handle.dispose();
    }
  }

  /// Runs [expectMeetsTapTargetGuideline], [expectMeetsTextContrastGuideline],
  /// and [expectMeetsLabeledTapTargetGuideline] together — the fastest way to
  /// get baseline accessibility coverage on a screen.
  ///
  /// ```dart
  /// await tester.expectMeetsAccessibilityGuidelines();
  /// ```
  Future<void> expectMeetsAccessibilityGuidelines({
    TargetPlatform platform = TargetPlatform.android,
  }) async {
    await expectMeetsTapTargetGuideline(platform: platform);
    await expectMeetsTextContrastGuideline();
    await expectMeetsLabeledTapTargetGuideline();
  }
}
