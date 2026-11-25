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
        for (language, title, action) in [
            ("es", "Bienvenido a HireKit", "Empecemos"),
            ("en", "Welcome to HireKit", "Get started")
        ] {
            let app = XCUIApplication()
            app.launchArguments = ["-AppleLanguages", "(\(language))", "-HKData.onboardingState", "pending"]
            app.launch()
            XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 10))
            XCTAssertTrue(app.buttons[action].exists)
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
