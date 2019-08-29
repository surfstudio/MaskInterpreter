import Foundation
import XCTest

@testable import MaskInterpreter

public class OneOfRuleTests: XCTestCase {

    // MARK: - Assert Successed

    /// Проверяет, что простое выражение правильно парсится
    public func testSimpleCaseParsedSuccess() {

        // Arrange

        let tokens: [Token] = [
            .oneOfStartSymbol,
            .constantSymbol("a"),
            .oneOfEndSymbol
        ]

        let rule = OneOfRule()

        // Act

        let parsed = try? rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        guard let result = parsed as? OneOfTreeNode else {
            XCTFail("Found nil but accepted OneOfTreeNode")
            return
        }

        let tokenString = tokens.reduce(into: "", { $0 += $1.rawView })

        XCTAssertEqual(tokenString, result.rawView)
        XCTAssertEqual(result.token, .oneOfStartSymbol)
        XCTAssertEqual(result.next.count, 1)
        XCTAssertEqual(result.next[0].token, tokens[1])
    }

    // MARK: - Assert Failed

    /// Проверяте, что стрим токенов без начального токена `.oneOfStartSymbol` не распарсится
    public func testWithoutStartTokenParseFailedWithNil() {

        // Arange

        let tokens: [Token] = [
            .constantSymbol("a"),
            .oneOfEndSymbol
        ]

         let rule = OneOfRule()

        // Act

         let parsed = try? rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        XCTAssertNil(parsed)
    }

    /// Проверяте, что стрим токенов без начального токена `.oneOfStartSymbol` не выкинет исключение
    public func testWithoutStartTokenParseNotThrows() {

        // Arange

        let tokens: [Token] = [
            .constantSymbol("a"),
            .oneOfEndSymbol
        ]

        let rule = OneOfRule()

        // Act - Assert

        XCTAssertNoThrow(try rule.parse(from: TokenStream(tokens: tokens)))
    }

    /// Проверяте, что стрим токенов без закрывающего токена `.onOfEndSymbol` выкинет исключение
    public func testWithoutEndTokenParseNotThrows() {

        // Arange

        let tokens: [Token] = [
            .oneOfStartSymbol,
            .constantSymbol("a")
        ]

        let rule = OneOfRule()

        // Act - Assert

        XCTAssertThrowsError(try rule.parse(from: TokenStream(tokens: tokens)), "", { (error) in
            guard case OneOfRuleError.awaitingEndRuleSymbol = error else {
                XCTFail("Awaiting OneOfRuleError.awaitingEndRuleSymbol but accepted \(error)")
                return
            }
        })
    }

    /// Проверяте, что стрим токенов без символов выкинет исключение
    public func testWithoutContentParseFailed() {

        // Arange

        let tokens: [Token] = [
            .oneOfStartSymbol,
            .oneOfEndSymbol
        ]

        let rule = OneOfRule()

        // Act - Assert

        XCTAssertThrowsError(try rule.parse(from: TokenStream(tokens: tokens)), "", { (error) in
            guard case OneOfRuleError.awaitingSymbolsButNotFound = error else {
                XCTFail("Awaiting OneOfRuleError.awaitingEndRuleSymbol but accepted \(error)")
                return
            }
        })
    }
}
