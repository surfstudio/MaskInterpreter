import Foundation
import XCTest

@testable import MaskInterpreter

public class CharStreamCurrentTests: XCTestCase {

    /// Проверяет, что метод `current` возвращает правильный символ
    public func testCurrentReturnRightSymbol() {

        // Arrange

        let chars: [Character] = ["a", "b", "c"]
        let str = String(chars)
        let index = 1
        let strIndex = str.index(after: str.startIndex)
        let stream = CharStream(string: str, position: strIndex)

        // Act

        let result = stream.current()

        // Assert

        guard let gurdResult = result else {
            XCTFail("Current returns nil value. Awaiting \(chars[index])")
            return
        }

        XCTAssertEqual(gurdResult, chars[index], "Current must return \(chars[index]) but accepted \(gurdResult)")
    }

    /// Проверяет, что метод `current` возвращает nil для пустой строки
    public func testCurrentReturnNillForEmptyString() {

        // Arrange
        let stream = CharStream(string: "")

        // Act

        let result = stream.current()

        // Assert

        XCTAssertNil(result, "Current should return nil for empty string but accepted \(result ?? "#")")
    }

    /// Проверяет, что метод `current` не изменяетп озицию указателя
    public func testCurrentNotSetCursor() {

        // Arrange

        let chars: [Character] = ["a", "b", "c"]
        let str = String(chars)
        let index = 1
        let strIndex = str.index(after: str.startIndex)
        let stream = CharStream(string: str, position: strIndex)

        // Act

        let result = stream.current()

        // Assert

        guard result != nil else {
            XCTFail("Current returns nil value. Awaiting \(chars[index])")
            return
        }

        XCTAssertEqual(strIndex, stream.position, "Current must not move position but after call position is \(stream.position) not \(strIndex)")
    }
}
