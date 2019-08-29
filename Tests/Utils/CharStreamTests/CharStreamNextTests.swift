import Foundation
import XCTest

@testable import MaskInterpreter

public class CharStreamNextTests: XCTestCase {

    /// Проверяет, что next возвращает правильный символ
    public func testReturnRightSymbol() {

        // Arrange

        let chars: [Character] = ["a", "b", "c"]
        let str = String(chars)
        let index = 2
        let strIndex = str.index(after: str.startIndex)
        let stream = CharStream(string: str, position: strIndex)

        // Act

        let result = stream.next()

        // Assert

        guard let gurdResult = result else {
            XCTFail("Current returns nil value. Awaiting \(chars[index])")
            return
        }

        XCTAssertEqual(gurdResult, chars[index], "Next must return \(chars[index]) but accepted \(gurdResult)")
    }

    /// Проверяет, что `next` не сдвигает указатель
    public func testChangePositionCurrectly() {

        // Arrange

        let chars: [Character] = ["a", "b", "c"]
        let str = String(chars)
        let index = 1
        let strIndex = str.index(after: str.startIndex)
        let stream = CharStream(string: str, position: strIndex)

        // Act

        let result = stream.next()

        // Assert

        guard result != nil else {
            XCTFail("Current returns nil value. Awaiting \(chars[index])")
            return
        }

        XCTAssertEqual(stream.position, strIndex, "next must not move position but after call position must be  \(strIndex) not \(stream.position)")
    }

    /// Проверяет, что метод `next` возвращает nil для пустой строки
    public func testReturnNillForEmptyString() {

        // Arrange
        let stream = CharStream(string: "")

        // Act

        let result = stream.next()

        // Assert

        XCTAssertNil(result, "next should return nil for empty string bu accepted \(String(describing: result))")
    }

    /// Проверяет, что `next` для последнего символа вернет nil и не случится краш
    public func testLastSimbolNotCrash() {

        // Arrange

        let str = "a"
        let stream = CharStream(string: str)

        // Act

        let result = stream.next()

        // Assert

        XCTAssertNil(result, "Next for last symbol must return nil but accepted \(String(describing: result))")
    }
}
