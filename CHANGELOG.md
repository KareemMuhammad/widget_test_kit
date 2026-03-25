## 0.0.1

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
