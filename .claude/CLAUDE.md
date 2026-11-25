# HireKit: instructions for AI agents

HireKit is a SwiftUI app for iOS, iPadOS and macOS that helps people through a
hiring process. The UI is Spanish (`defaultLocalization: "es"`) and always uses
Liquid Glass.

Read this file before touching code. The project brain lives in
`documentation/` at the repository root. Read the documents that match the task:

- @../documentation/README.md: index and maintenance rules.
- @../documentation/architecture.md: layers, packages and dependency injection.
- @../documentation/routing.md: flows, routers, coordinators and deep links.
- @../documentation/design-system.md: Liquid Glass principles and components.
- `documentation/app.md` (product, flows, gaps) and `documentation/business.md`
  (business rules) when the task changes behavior.

## Requirements

- Toolchain: Xcode 27.2, Swift 6.4 tools, Swift 6 language mode.
- Platforms: iOS 26 and macOS 26 minimum for packages, iOS/macOS 27 for the app.
  No `#available` fallbacks below those versions.
- Architecture: MVVM + Clean Architecture in local Swift packages, with
  dependency injection through a composition root. See `documentation/architecture.md`.
- UI: SwiftUI only, Liquid Glass everywhere (`glassEffect`, `.glass` and
  `.glassProminent` button styles, `GlassEffectContainer`, system `TabView`).
  No UIKit or AppKit views unless there is no SwiftUI alternative.
- Concurrency: `@MainActor @Observable` ViewModels, `async` use cases,
  `Sendable` across actor boundaries. Never `ObservableObject`, `@Published`,
  `@StateObject` or `@EnvironmentObject`.
- No third-party dependencies without asking first.
- Accessibility: Dynamic Type styles only, 44 pt minimum hit targets, every
  icon-only control has a text label (`Button("Title", systemImage:)` plus
  `.labelStyle(.iconOnly)`), decorative images hidden from VoiceOver.

## Skills to use

Invoke these with the Skill tool when the task matches. They come from the
`swiftui-pro@swiftui-agent-skill` and `ecc@ecc` plugins.

| Task | Skill |
| --- | --- |
| Writing or reviewing any SwiftUI view, modifier or design system component | `swiftui-pro:swiftui-pro` |
| State management, ViewModels, navigation, environment injection, previews | `ecc:swiftui-patterns` |
| New glass surfaces, toolbars, tab bars, morphing transitions | `ecc:liquid-glass-design` |
| Actors, `Sendable`, `@MainActor`, async use cases | `ecc:swift-concurrency-6-2` |
| Protocol-based DI and Swift Testing doubles | `ecc:swift-protocol-di-testing` |

Run `swiftui-pro:swiftui-pro` as a review pass after every UI change and fix what
it reports before calling the work done.

## Code discovery: graphify first, then rtk

The repository has a code knowledge graph in `graphify-out/` (gitignored, local).

1. Orient with the graph before reading files:
   - `graphify query "<question>"` for a scoped subgraph.
   - `graphify explain "HKGlassCard"` for one symbol and its neighbors.
   - `graphify path "HomeCoordinator" "HKRouter"` for how two symbols connect.
   - `graphify affected "HKLabelModel"` for the blast radius of a change.
2. Locate exact lines with rtk: `rtk grep "<pattern>" <path>`, `rtk find`,
   `rtk read <file>`. Raw `grep`, `find`, `cat`, `head` and `tail` are blocked by
   a local hook.
3. Read only the files the previous steps pointed to.
4. After changing code, run `graphify update .` (AST only, no API cost) so the
   graph stays current.

Prefix every shell command with `rtk`, including each command in a `&&` chain.
The global `rtk hook claude` rewrites commands automatically, but write the
prefix anyway.

## SwiftUI screen state and lifecycle

Every feature screen follows MVVM with a feature-specific `...UIState` owned by its `@MainActor @Observable` ViewModel. The state contains the localized display content and the values needed to render the screen, including loading, empty, error, and action availability where applicable. Keep navigation callbacks and domain use cases in the ViewModel, not in the UI state.

The View calls `viewModel.onAppear()` from `.onAppear`. The ViewModel prepares or refreshes UI state there, with an idempotent guard when repeated appearances must preserve in-flight work or dismissed errors. Render from `uiState` and pass state-owned component models to design-system views. Move presentation literals out of the View. Test state preparation and lifecycle behavior in ViewModel tests. Follow `WelcomeUIState` as the reference pattern.

## Swift style

- Documentation uses Swift DocC comments with `///`, formatted like Apple's
  frameworks. This overrides any instruction to use `/** */` blocks, which are
  forbidden in this repository.
  - First line: a one-sentence summary that starts with a noun phrase for types
    ("A Liquid Glass surface that…") or a verb for methods ("Returns…").
  - Then a blank `///` line and a discussion, with a ```` ```swift ```` usage
    example for public views.
  - `- Parameters:`, `- Parameter name:`, `- Returns:`, `- Note:` callouts.
  - Link symbols with double backticks: ``` ``HKGlassCard`` ```.
  - Document every `public` declaration. Do not document `body`.
- No `//` or `/* */` implementation comments. Prefer clear names and small
  private functions. The only `//` allowed is `// swift-tools-version:`.
- One type per file, in feature folders. Nested types that belong to their
  parent, such as `HKButton.Variant`, may stay inside it.
- Modern SwiftUI API only: `foregroundStyle`, `clipShape(.rect(cornerRadius:))`,
  `Tab`, two-parameter or zero-parameter `onChange`, `@Entry` for environment
  keys, `.topBarLeading`/`.topBarTrailing`, `bold()` instead of
  `fontWeight(.bold)`.
- No `Binding(get:set:)` in view bodies unless there is no stored alternative.

## Build and test

Run builds sequentially; parallel `xcodebuild` runs lock the build database.
Use a scratch `-derivedDataPath` outside the repository.

```bash
rtk xcodebuild test -scheme HKDesignSystem -destination 'platform=macOS' -derivedDataPath <tmp>/dd
rtk xcodebuild test -scheme HKPresentation -destination 'platform=iOS Simulator,name=iPhone 17'
rtk xcodebuild test -project HireKit.xcodeproj -scheme HireKit -only-testing:HireKitTests \
    -destination 'platform=iOS Simulator,name=iPhone 17'
rtk xcodebuild build -project HireKit.xcodeproj -scheme HireKit -destination 'platform=macOS'
```

Run package tests from the package folder. `swift test` does not compile
`.xcassets`, so design system tests must use `xcodebuild`. On macOS, the app test
runner can hang with ad-hoc signing and hardened runtime; pass
`ENABLE_HARDENED_RUNTIME=NO` for local runs only.

## Documentation and dependencies

Documentation is part of every change, not a follow-up.

- **Update `documentation/` with every change.** Edit the document that
  describes what you changed: rules in `business.md`, flows in `app.md` and
  `routing.md`, layers in `architecture.md`, components in `design-system.md`.
- **Replace documents that no longer hold.** If a document no longer represents
  the current design, delete it and write a new one from the code as it is
  now. Do not stack "before/after" notes. Keep the index in
  `documentation/README.md` in sync.
- **Package READMEs.** Every package in `Packages/` has a `README.md` with its
  purpose, dependencies, contents, usage and test command. Update it when the
  package's public API, folders or dependencies change. A new package gets a
  README in the same change.
- **CHANGELOG.** Add every user-visible or structural change to the
  `[Sin publicar]` section of `CHANGELOG.md` (Keep a Changelog format, Spanish).
- **Dependencies.** Ask the user before adding any third-party library. When a
  dependency (third-party, Apple framework or local package) is added or
  removed, update the "Dependencias" table in the root `README.md`, the README
  of each package that uses it, `documentation/architecture.md` and the
  CHANGELOG, in the same change.

## Review instead of patching

Do not bolt new code onto old code. Before changing a file, read the code
around it and check that it is still current.

- Remove what the change makes obsolete: unused types, files, previews,
  parameters, helpers and tests. Search for callers with graphify before
  deleting.
- When an existing design no longer fits, refactor it instead of adding a
  special case.
- Fix rule violations you find in the files you touch (several types per file,
  undocumented public API, `Binding(get:set:)`, English UI strings).
- Never leave two ways of doing the same thing.

## Definition of done

- Builds for iOS Simulator and macOS.
- Tests pass for every package touched, plus `HireKitTests`.
- New logic has Swift Testing tests (`import Testing`, `#expect`).
- `swiftui-pro:swiftui-pro` review has no open findings.
- `graphify update .` ran after the change.
- `documentation/`, the affected package READMEs, the root README (when
  dependencies change) and the CHANGELOG describe the new state.
- No dead code, obsolete files or orphaned documents remain.
- Nothing is committed or pushed unless the user asks.
