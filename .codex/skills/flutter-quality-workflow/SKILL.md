---
name: flutter-quality-workflow
description: Apply this repository's Flutter code conventions, module boundaries, and mandatory quality checks when adding, changing, reviewing, or refactoring Flutter/Dart features. Use for feature implementation, bug fixes, architecture changes, and pre-commit build or test validation in this project.
---

# Flutter Quality Workflow

## Inspect first

1. Read `pubspec.yaml`, `analysis_options.yaml`, `docs/architecture.md`, and the nearest analogous feature before editing.
2. Preserve the existing feature-first layout under `lib/features/<feature>/`.
3. Treat `lib/core/` as shared abstractions only; do not place feature-specific UI or state there.
4. Follow any repository-local `AGENTS.md` instructions before touching scoped files.

## Module boundaries

- Keep widgets and pages in `ui/`; keep feature-only reusable widgets in `ui/widgets/`.
- Put UI state and orchestration in `provider/` using the existing Provider/`ChangeNotifier` pattern.
- Keep domain entities as pure Dart models in `lib/core/models/`; include explicit mapping only where persistence requires it.
- Define persistence contracts in `lib/core/repositories/` and put storage-specific work in their implementations or `lib/core/database/`.
- Make pages depend on providers or repository contracts, never directly on database helpers or SQL.
- Keep feature dependencies directional: UI → provider → repository → database. Do not import UI from lower layers.
- Add localization strings to both `lib/l10n/app_en.arb` and `lib/l10n/app_zh.arb`; use generated localizations rather than hard-coded user-facing text.

## Code conventions

- Match Dart and Flutter lints configured by `analysis_options.yaml`; prefer clear, null-safe, formatted code.
- Keep widgets small and extract cohesive private or reusable widgets instead of growing large `build` methods.
- Prefer immutable inputs (`final` fields and `const` constructors/widgets) where valid.
- Validate external or persisted data at boundaries and expose actionable errors or empty/loading states in UI.
- Avoid unrelated refactors, generated files, secrets, and platform changes unless the task requires them.
- Add or update focused unit/widget tests for behavior changes, using repository contracts that can be mocked or faked.

## Completion checklist

1. Run `dart format` on every changed Dart file.
2. Run `flutter analyze` and resolve all newly introduced diagnostics.
3. Run `flutter test`; update or add tests until the changed behavior is covered.
4. Run the narrowest relevant build check: use `flutter build <target>` for a platform-specific change, otherwise use `flutter build web` when the web toolchain is available.
5. If a build cannot run because the host lacks its platform toolchain, report the exact skipped command and reason; do not claim it passed.
6. Review `git diff --check` and `git diff` to confirm scope, formatting, localization, and module boundaries.
7. Summarize implementation, tests, build status, and known limitations with exact commands.
