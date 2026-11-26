import HKDesignSystem
import HKPresentation
import SwiftUI
import Testing

@MainActor
struct SignUpViewModelTests {
    private func makeViewModel(
        sleeper: ManualSleeper = ManualSleeper(),
        onStart: @escaping @MainActor () -> Void = {},
        onSignIn: @escaping @MainActor () -> Void = {}
    ) -> SignUpViewModel {
        SignUpViewModel(
            sleep: { try await sleeper.sleep($0) },
            onStart: onStart,
            onSignIn: onSignIn
        )
    }

    @Test func firstAppearancePreparesTheIntroduction() throws {
        let viewModel = makeViewModel()
        #expect(viewModel.uiState == nil)
        viewModel.onAppear(allowsAutoAdvance: false)
        let state = try #require(viewModel.uiState)
        #expect(state.titleLabel.text == "sign_up_title_txt")
        #expect(state.descriptionLabel.text == "sign_up_description_txt")
        #expect(state.steps == [.personalInformation, .contactInformation, .getStarted])
        #expect(state.carousel.items.count == 3)
        #expect(state.carousel.selectedIndex == 0)
        #expect(state.startButton.title == "sign_up_start_button_txt")
        #expect(state.signInButton.title == "sign_up_existing_account_button_txt")
    }

    @Test func carouselAdvancesOnItsOwnAndWrapsAround() async {
        let sleeper = ManualSleeper()
        let viewModel = makeViewModel(sleeper: sleeper)
        viewModel.onAppear(allowsAutoAdvance: true)

        for expected in [1, 2, 0] {
            await waitUntil { await sleeper.sleepCount > 0 }
            await sleeper.wakeAll()
            await waitUntil { viewModel.uiState?.selectedStep == expected }
            #expect(viewModel.uiState?.selectedStep == expected)
        }
        viewModel.onDisappear()
        await sleeper.wakeAll()
    }

    @Test func manualSelectionRestartsTheTimer() async {
        let sleeper = ManualSleeper()
        let viewModel = makeViewModel(sleeper: sleeper)
        viewModel.onAppear(allowsAutoAdvance: true)
        await waitUntil { await sleeper.sleepCount == 1 }

        viewModel.select(2)
        #expect(viewModel.uiState?.selectedStep == 2)
        await waitUntil { await sleeper.sleepCount == 2 }
        #expect(await sleeper.sleepCount == 2)

        await sleeper.wakeAll()
        await waitUntil { viewModel.uiState?.selectedStep == 0 }
        #expect(viewModel.uiState?.selectedStep == 0)
        viewModel.onDisappear()
        await sleeper.wakeAll()
    }

    @Test func selectionOutsideTheStepsIsIgnored() {
        let viewModel = makeViewModel()
        viewModel.onAppear(allowsAutoAdvance: false)
        viewModel.select(7)
        #expect(viewModel.uiState?.selectedStep == 0)
    }

    @Test func disallowedAutoAdvanceKeepsTheCarouselStill() async {
        let sleeper = ManualSleeper()
        let viewModel = makeViewModel(sleeper: sleeper)
        viewModel.onAppear(allowsAutoAdvance: false)
        for _ in 0..<20 { await Task.yield() }
        #expect(viewModel.uiState?.isAutoAdvanceEnabled == false)
        #expect(await sleeper.sleepCount == 0)

        viewModel.allowsAutoAdvanceChanged(true)
        await waitUntil { await sleeper.sleepCount == 1 }
        #expect(viewModel.uiState?.isAutoAdvanceEnabled == true)
        viewModel.onDisappear()
        await sleeper.wakeAll()
    }

    @Test func startNavigatesOnceUntilTheScreenAppearsAgain() {
        var starts = 0
        var signIns = 0
        let viewModel = makeViewModel(onStart: { starts += 1 }, onSignIn: { signIns += 1 })
        viewModel.start()
        #expect(starts == 0)

        viewModel.onAppear(allowsAutoAdvance: false)
        viewModel.uiState?.startButton.action()
        viewModel.start()
        viewModel.signIn()
        #expect(starts == 1)
        #expect(signIns == 0)

        viewModel.onAppear(allowsAutoAdvance: false)
        viewModel.signIn()
        #expect(signIns == 1)
    }
}
