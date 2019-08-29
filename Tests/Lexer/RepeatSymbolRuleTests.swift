import Foundation
import XCTest

@testable import MaskInterpreter

public class RepeatSymbolRuleTests: XCTestCase {

    // MARK: - Assert Successed

    /// Проверяет, стрим с `constantSymbol` парсится успешно
    public func testRepeatConstantsSymbolCaseParsedSuccess() {
        // Arrange

        let tokens: [Token] = [
            .constantSymbol("1"),
            .repeaterSymbol(.oneOrMore)
        ]

        let rule = RepeatSymbolRule()

        // Act

        let parsed = try? rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        guard let result = parsed as? RepeatTokenTreeNode else {
            XCTFail("Result is nil but awaiting RepeatTokenTreeNode")
            return
        }

        let string = tokens.reduce(into: "", { $0 += $1.rawView })

        XCTAssertEqual(string, result.rawView)
        XCTAssertEqual(result.repeated.token.rawView, tokens[0].rawView)
    }

    /// Проверяет, стрим с `specialSymbol` парсится успешно
    public func testRepeatSpecialSymbolCaseParsedSuccess() {
        // Arrange

        let tokens: [Token] = [
            .specialSymbol(.number),
            .repeaterSymbol(.oneOrMore)
        ]

        let rule = RepeatSymbolRule()

        // Act

        let parsed = try? rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        guard let result = parsed as? RepeatTokenTreeNode else {
            XCTFail("Result is nil but awaiting RepeatTokenTreeNode")
            return
        }

        let string = tokens.reduce(into: "", { $0 += $1.rawView })

        XCTAssertEqual(string, result.rawView)
        XCTAssertEqual(result.repeated.token.rawView, tokens[0].rawView)
    }

    /// Проверяет, стрим с OneOf парсится успешно
    public func testRepeatOneOfCaseParsedSuccess() {
        // Arrange

        let tokens: [Token] = [
            .oneOfStartSymbol,
            .constantSymbol("1"),
            .oneOfEndSymbol,
            .repeaterSymbol(.oneOrMore)
        ]

        let rule = RepeatSymbolRule()

        // Act

        let parsed = try? rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        guard let result = parsed as? RepeatTokenTreeNode else {
            XCTFail("Result is nil but awaiting RepeatTokenTreeNode")
            return
        }

        let string = tokens.reduce(into: "", { $0 += $1.rawView })

        XCTAssertEqual(string, result.rawView)

        guard let oneOf = result.repeated as? OneOfTreeNode else {
            XCTFail("result.repeated must be OneOfTreeNode")
            return
        }

        XCTAssertEqual(oneOf.next.first?.token.rawView, tokens[1].rawView)
    }

    /// Проверяет, стрим без символа повторения не выбрасывает ошибку
    public func testPatsingWithoutRepeatSymbolNotThrows() {
        // Arrange

        let tokens: [Token] = [
            .specialSymbol(.number)
        ]

        let rule = RepeatSymbolRule()

        // Act - Assert

         XCTAssertNoThrow(try rule.parse(from: TokenStream(tokens: tokens)))
    }

    // MARK: - Assert Failed

    /// Проверяет, стрим без символа повторения не парсится
    public func testBadStreamParseFailed() {
        // Arrange

        let tokens: [Token] = [
            .specialSymbol(.number)
        ]

        let rule = RepeatSymbolRule()

        // Act

        let parsed = try? rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        XCTAssertNil(parsed)
    }
}
