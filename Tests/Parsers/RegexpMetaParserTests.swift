import Foundation
import XCTest

@testable import MaskInterpreter

public class RegexpMetaParserTests: XCTestCase {

    // MARK: - Assert Successed

    /// Проверяет, что полное выражение успешно парсится
    public func testFullExpressionParsed() {

        // Arrange

        let parser = RegexpMetaParser()
        let arrangeMin = 1
        let arrangeMax = 2
        let stream = CharStream(string: "${\(arrangeMin),\(arrangeMax)}")

        // Act

        let token = try? parser.parse(from: stream)

        // Assert

        guard let result = token else {
            XCTFail("Result must not be nil")
            return
        }

        switch result {
        case .regexpMeta(let min, let max):
            XCTAssertEqual(min, arrangeMin)
            XCTAssertEqual(max, arrangeMax)
        default:
            XCTFail("Token must be `.regexpMeta`")
        }
    }

    /// Проверяет, что короткое выражение успешно парсится
    public func testShortExpressionParsed() {

        // Arrange

        let parser = RegexpMetaParser()
        let arrangeMin = 1
        let stream = CharStream(string: "${\(arrangeMin)}")

        // Act

        let token = try? parser.parse(from: stream)

        // Assert

        guard let result = token else {
            XCTFail("Result must not be nil")
            return
        }

        switch result {
        case .regexpMeta(let min, let max):
            XCTAssertEqual(min, arrangeMin)
            XCTAssertNil(max)
        default:
            XCTFail("Token must be `.regexpMeta`")
        }
    }

    // MARK: - Assert Failed

    /// Проверяет, что полное выражение в котором
    /// вместо максимума записана строка вместо целого - выбросит исключение
    public func testFullExpInMaxBadIntThorowsExeption() {
        // Arrange

        let parser = RegexpMetaParser()
        let stream = CharStream(string: "${1,h}")

        // Act - Assert

        XCTAssertThrowsError(try parser.parse(from: stream), "") { (error) in
            guard case ParseMetaError.cantParseMaxAsInt = error else {
                XCTFail("Error must be ParseMetaError.cantParseMaxAsInt but accepted \(error)")
                return
            }
        }
    }

    /// Проверяет, что полное выражение в котором
    /// вместо минимума записана строка вместо целого - выбросит исключение
    public func testFullExpInMinBadIntThorowsExeption() {
        // Arrange

        let parser = RegexpMetaParser()
        let stream = CharStream(string: "${h,h}")

        // Act - Assert

        XCTAssertThrowsError(try parser.parse(from: stream), "") { (error) in
            guard case ParseMetaError.cantParseMinAsInt = error else {
                XCTFail("Error must be ParseMetaError.cantParseMinAsInt but accepted \(error)")
                return
            }
        }
    }

    public func testBadExpressionNotParse() {
        // Arrange

        let parser = RegexpMetaParser()
        let stream = CharStream(string: "${,}")

        // Act

        let result = try? parser.parse(from: stream)

        // Assert

        guard let gRes = result else {
            return
        }

        XCTAssertNil(gRes)
    }
}
