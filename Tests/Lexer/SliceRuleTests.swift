import Foundation
import XCTest

@testable import MaskInterpreter

public class SliceRuleTests: XCTestCase {

    // MARK: - Assert Successed

    /// Проверяем простой кейс парсится правильно
    public func testRuleWorkSuccess() {

        // Arrange

        let tokens: [Token] = [
            .constantSymbol("1"),
            .sliceSymbol,
            .constantSymbol("2")
        ]

        let rule = SliceRule()

        // Act

        let parsed = rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        guard let result = parsed as? SliceTreeNode else {
            XCTFail("Result is nil but awaiting SliceTreeNode")
            return
        }

        let tokensString = tokens.reduce(into: "", { $0 += $1.rawView })

        XCTAssertEqual(tokensString, result.rawView)
        XCTAssertEqual(result.left.rawView, tokens[0].rawView)
        XCTAssertEqual(result.token.rawView, tokens[1].rawView)
        XCTAssertEqual(result.right.rawView, tokens[2].rawView)
    }

    // MARK: - Assert Failed

    /// Проверяем, что простой кейс с ошибкой не парсится
    public func testRuleParsingFailed() {

        // Arrange

        let tokens: [Token] = [
            .constantSymbol("1"),
            .constantSymbol("2")
        ]

        let rule = SliceRule()

        // Act

        let parsed = rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        XCTAssertNil(parsed)
    }

    /// Проверяем, что кейс без левого символа с ошибкой не парсится
    public func testWithoutLeftParsingFailed() {

        // Arrange

        let tokens: [Token] = [
            .sliceSymbol,
            .constantSymbol("2")
        ]

        let rule = SliceRule()

        // Act

        let parsed = rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        XCTAssertNil(parsed)
    }

    /// Проверяем, что кейс без правого символа с ошибкой не парсится
    public func testWithoutRightParsingFailed() {

        // Arrange

        let tokens: [Token] = [
            .constantSymbol("1"),
            .sliceSymbol
        ]

        let rule = SliceRule()

        // Act

        let parsed = rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        XCTAssertNil(parsed)
    }

    /// Проверяем, что со специальным символом не парсится
    public func testWithSpecialSymbolParsingFailed() {

        // Arrange

        let tokens: [Token] = [
            .constantSymbol("1"),
            .sliceSymbol,
            .specialSymbol(.number)
        ]

        let rule = SliceRule()

        // Act

        let parsed = rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        XCTAssertNil(parsed)
    }
}
