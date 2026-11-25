import XCTest

final class HireKitUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAppLaunches() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertEqual(app.state, .runningForeground)
    }

    @MainActor
    func testWelcomeUsesTheSelectedLanguage() {
        for (language, title, action, signIn) in [
            ("es", "Bienvenido a HireKit", "Empecemos", "Inicia sesión"),
            ("en", "Welcome to HireKit", "Get started", "Sign in to your account")
        ] {
            let app = XCUIApplication()
            app.launchArguments = ["-AppleLanguages", "(\(language))", "-HKData.onboardingState", "pending"]
            app.launch()
            XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 10))
            app.buttons[action].tap()
            XCTAssertTrue(app.staticTexts[signIn].waitForExistence(timeout: 10))
            app.terminate()
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
