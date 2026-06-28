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
