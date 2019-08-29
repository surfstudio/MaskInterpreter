import Foundation
import XCTest

@testable import MaskInterpreter

public class RegexpStartSymbolParserTests: XCTestCase {

    // MARK: - Assert Successed

    /// Проверяет, что верное выражение правильно распарсится
    public func testParseSuccessed() {
        // Arrange

        let parser = RegexpStartSymbolParser()
        let stream = CharStream(string: "<!^")

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertEqual(result, Token.regexpStartSymbol)
    }

    /// Проверяет, что верное выражение правильно сдвигает позицию
    public func testMovePosition() {
        // Arrange

        let parser = RegexpStartSymbolParser()
        let stream = CharStream(string: "<!^f")
        let start = stream.position

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertNotNil(result)
        XCTAssertEqual(stream.position, stream.string.index(start, offsetBy: 3))
    }

    // MARK: - Assert Failed

    /// Проверяет, что парсинг неправильного выражения вернет nil
    func testBadExpressionNotParse() {
        // Arrange

        let parser = RegexpStartSymbolParser()
        let stream = CharStream(string: "234")

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertNil(result)
    }

    /// Проверяет, что в случае неудачного парсинга позиция не меняется
    func testNotMovePositionInBadExpressionCase() {
        // Arrange

        let parser = RegexpStartSymbolParser()
        let stream = CharStream(string: "123")
        let start = stream.position

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertNil(result)
        XCTAssertEqual(stream.position, start)
    }

    /// Проверяем, что для пустого стрима вернется nil
    func testReturnsNilForEmptyStream() {
        // Arrange

        let parser = RegexpStartSymbolParser()
        let stream = CharStream(string: "")

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertNil(result)
    }
}
