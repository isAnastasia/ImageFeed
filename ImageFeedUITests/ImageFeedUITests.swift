import XCTest

final class ImageFeedUITests: XCTestCase {
    private let email: String = ""
    private let password: String = ""
    private let fullName: String = ""
    private let username: String = ""

    private let app = XCUIApplication()
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
        
    func testAuth() throws {

        sleep(5)
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]

        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        sleep(8)
        let loginTextField = webView.descendants(matching: .textField).element
        
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(email)
        webView.tap()
        webView.swipeUp()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()

        webView.buttons["Login"].tap()

        sleep(5)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 6))
    }
        
    func testFeed() throws {
        sleep(10)
        let tablesQuery = app.tables

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            cell.swipeUp()
        sleep(2)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

        cellToLike.buttons["like button"].tap()
        sleep(5)
        cellToLike.buttons["like button"].tap()

        sleep(5)

        cellToLike.tap()

        sleep(60)

        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(5)
            
        image.pinch(withScale: 3, velocity: 1)
            
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav back button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["\(fullName)"].exists)
        XCTAssertTrue(app.staticTexts["\(username)"].exists)

        app.buttons["logout button"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
