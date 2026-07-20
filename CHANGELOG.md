## 0.3.0

### 🚀 New Features

* **Accessibility extensions** – `expectMeetsTapTargetGuideline`, `expectMeetsTextContrastGuideline`, `expectMeetsLabeledTapTargetGuideline`, and the aggregate `expectMeetsAccessibilityGuidelines` wrap Flutter's built-in accessibility guideline checks into single-call assertions.
* **Network image mocking** – `mockNetworkImages()` intercepts `Image.network`/`NetworkImage` requests with an in-memory placeholder so widget and golden tests no longer fail or hang without real network access.
* **`TestApp.wrapper`** – inject `ProviderScope`, `BlocProvider`, or any other ancestor widget around the `MaterialApp` without this package depending on a state-management library.
* **Multi-locale goldens** – `expectGoldenForLocales()` pumps a widget once per locale and captures a golden per locale, for catching RTL/overflow/truncation regressions.
* **More style matchers** – `toHaveElevation`, `toHaveBoxShadow`, `toHaveGradient`, `toHaveTextAlign`, `toHaveFontWeight`, `toHaveMaxLines`.

### 🔧 Improvements

* Added a runnable `example/` app with widget tests demonstrating forms, gestures, the robot pattern, accessibility, and network image mocking.
* Added a GitHub Actions CI workflow running formatting, analysis, and tests for both the package and the example app.
* Enabled `public_member_api_docs` and additional lints in `analysis_options.yaml`.
* Fixed `.gitignore` build/coverage patterns so nested packages (like `example/`) don't leak build artifacts into the published package.

## 0.2.0

### 🚀 New Features

* **Golden path overrides** – `expectGolden` and `expectWidgetGolden` now support custom `goldenPath` values while keeping `goldens/[name].png` as the default.

### 🔧 Improvements

* Hardened finder helpers so documented dropdown, hint, and label lookups behave consistently.
* Improved dialog dismissal, scroll helpers, golden surface cleanup, list matcher failure messages, and direct hidden-widget visibility checks.
* Added focused test coverage for navigation, gestures, goldens, list matchers, style matchers, finder helpers, visibility edge cases, and the `not()` matcher.
* Cleaned package metadata by removing generated template comments from `pubspec.yaml`.

## 0.1.0

### 🚀 New Features

* **Navigation extensions** – `navigateTo`, `goBack`, `expectRoute`, `expectDialog`, `expectNoDialog`, `expectBottomSheet`, `dismissDialog`, `expectSnackBar`.
* **Gesture extensions** – `swipeLeft`, `swipeRight`, `swipeUp`, `swipeDown`, `longPressOn`, `doubleTapOn`, `dragSliderTo`, `scrollUntilFound`, `pullToRefresh`.
* **List/Scrollable matchers** – `toHaveItemCount`, `toContainWidget`, `toBeScrollable`, `toBeEmptyList`.
* **Style/Visual matchers** – `toHaveOpacity`, `toHaveColor`, `toHaveFontSize`, `toHavePadding`, `toHaveDecoration`, `toHaveBorderRadius`, `toHaveAlignment`.
* **ScreenRobot** – abstract base class for the page-object/robot pattern.
* **Golden test extensions** – `expectGolden`, `expectWidgetGolden`, `setScreenSize`, `resetScreenSize`.
* **`not()` matcher combinator** – negate any matcher for expressive assertions.
* **Expanded finders** – `find.iconWidget`, `find.imageAsset`, `find.listTile`, `find.tabWithLabel`, `find.dropdown`, `find.chip`, `find.byHintText`, `find.byLabelText`.

### 🔧 Improvements

* Bumped package to `0.1.0` to signal feature-complete v1 preview.

## 0.0.2

* Initial release.
* **TestApp** – minimal `MaterialApp` + `Scaffold` wrapper for widget tests.
* **Expectation extensions** – `expectThat`, `expectThatSingle`, `shouldBe`, `expectThatEventually`.
* **Form extensions** – `completeForm`, `updateField`, `updateForm`, `submitForm`, `clearForm`, `updateFieldWithRetry`.
* **Finder extensions** – `find.button()` for any `ButtonStyleButton` / `IconButton`.
* **FieldFinders** utility – `byKey`, `byLabel`, `byHint`, `bySemantics`.
* **Matchers**
  * Visibility: `toBeVisible`, `toBeHidden`, `toNotExist`.
  * State: `toBeEnabled`, `toBeDisabled`, `toBeChecked`, `toBeUnchecked`, `toHaveValue`.
  * Content: `toHaveText`, `toContainText`, `toHaveSemantics`.
  * Layout: `toHaveSize`, `toBePositioned`, `toBeWithin`.
