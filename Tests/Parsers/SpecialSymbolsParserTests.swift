import Foundation
import XCTest

@testable import MaskInterpreter

extension SpecialSymbolType {

    public static var allCases: [String] {
        return [
            SpecialSymbolType.notNumber.rawValue,
            SpecialSymbolType.notSpace.rawValue,
            SpecialSymbolType.notWord.rawValue,
            SpecialSymbolType.number.rawValue,
            SpecialSymbolType.space.rawValue,
            SpecialSymbolType.word.rawValue
        ]
    }
}

public class SpecialSymbolsParserTests: XCTestCase {

    // MARK: - Assert Successed

    /// Проверяет, что парсер правильно парсит все возможные варианты `SpecialSymbolType`
    public func testParserWorkSuccess() {
        // Arrange

        let parser = SpecialSymbolsParser()
        let string = SpecialSymbolType.allCases.reduce("", { $0 + $1 })

        // Act

        let parsed = SpecialSymbolType.allCases.compactMap { parser.parse(from: CharStream(string: "\($0)")) }

        // Assert

        XCTAssertEqual(string.count / 2, parsed.count)
        XCTAssertTrue(parsed.allSatisfy { item in
            if case Token.specialSymbol(_) = item {
                return true
            }
            return false
        })

        XCTAssertEqual(string, parsed.reduce(into: "", { $0 += $1.rawView }))
    }

    public func testParserMovePointer() {
        // Arrange

        let parser = SpecialSymbolsParser()
        let stream = CharStream(string: "\\da")
        let startPosition = stream.position

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertNotNil(result)
        XCTAssertEqual(stream.position, stream.string.index(startPosition, offsetBy: 2))
    }

    public func testParserNotMovePointerOfParseFailed() {
        // Arrange

        let parser = SpecialSymbolsParser()
        let stream = CharStream(string: "da")
        let startPosition = stream.position

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertNil(result)
        XCTAssertEqual(stream.position, startPosition)
    }

    // MARK: - Assert Failed

    /// Проверяет, что парсер вернет nil для пустого стрима.
    public func testEmptyStreamParsingFailed() {
        // Arrange

        let parser = SpecialSymbolsParser()
        let stream = CharStream(string: "")

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertNil(result)
    }

    /// Проверяет, что символ, который не входит во множество зарезирвированных символов не парсится (возврщается в nil).
    public func testNotSpecialSymbolNotParsed() {
        // Arrange

        let parser = SpecialSymbolsParser()
        let stream = CharStream(string: "\\-")

        // Act

        let result = parser.parse(from: stream)

        // Assert

        XCTAssertNil(result)
    }
}
