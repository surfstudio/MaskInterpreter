import Foundation
import XCTest

@testable import MaskInterpreter

public class CharStreamPopTests: XCTestCase {

    /// Проверяет, что pop возвращает правильный символ
    public func testReturnRightSymbol() {

        // Arrange

        let chars: [Character] = ["a", "b", "c"]
        let str = String(chars)
        let index = 1
        let strIndex = str.index(after: str.startIndex)
        let stream = CharStream(string: str, position: strIndex)

        // Act

        let result = stream.pop()

        // Assert

        guard let gurdResult = result else {
            XCTFail("Current returns nil value. Awaiting \(chars[index])")
            return
        }

        XCTAssertEqual(gurdResult, chars[index], "Pop should return \(chars[index]) but accepter \(gurdResult)")
    }

    /// Проверяет, что `pop` сдвигает указатель на один символ вперед
    public func testChangePositionCurrectly() {

        // Arrange

        let chars: [Character] = ["a", "b", "c"]
        let str = String(chars)
        let index = 1
        let strIndex = str.index(after: str.startIndex)
        let stream = CharStream(string: str, position: strIndex)

        // Act

        let result = stream.pop()

        // Assert

        guard result != nil else {
            XCTFail("Current returns nil value. Awaiting \(chars[index])")
            return
        }

        let awaiting = stream.position
        let accepted = str.index(after: strIndex)

        XCTAssertEqual(awaiting, accepted, "Position must be equak but \(awaiting) not eqal to \(accepted)")
    }

    /// Проверяет, что метод `pop` возвращает nil для пустой строки
    public func testReturnNillForEmptyString() {

        // Arrange
        let stream = CharStream(string: "")

        // Act

        let result = stream.pop()

        // Assert

        XCTAssertNil(result, "Pop must not return nil")
    }

    /// Проверяет, что pop для последнего символа вернет символ и не случится крэш
    public func testLastSimbolNotCrash() {

        // Arrange

        let str = "a"
        let stream = CharStream(string: str)
        let strIndex = str.endIndex

        // Act

        let result = stream.pop()

        // Assert

        guard result != nil else {
            XCTFail("Current returns nil value. Awaiting \(str)")
            return
        }

        XCTAssertEqual(strIndex, stream.position, "After pop, stream position must be equal to string end index")
    }
}
