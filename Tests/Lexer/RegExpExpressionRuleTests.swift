import Foundation
import XCTest

@testable import MaskInterpreter

public class RegExpExpressionRuleTests: XCTestCase {

    /// Проверяет, что сложный регэксп из всех токенов парсится успешно
    public func testfullTokenStreamParseSuccessed() {

        // Arrange

        let tokens: [Token] = [
            .regexpStartSymbol,
            .constantSymbol("1"),
            .constantSymbol("."),
            .repeaterSymbol(.oneOrMore),
            .specialSymbol(.number),
            .repeaterSymbol(.zeroOrMore),
            .oneOfStartSymbol,
            .constantSymbol("1"),
            .oneOfEndSymbol,
            .repeaterSymbol(.zeroOrMore),
            .regexpMeta(10, 15),
            .regexpEndSymbol
        ]

        let stringView = "RE(10,15)[CS(1),RT(+)[CS(.)],RT(*)[SS(\\d)],RT(*)[OO()[CS(1)]]]"
        let rule = RegExpExpressionRule()

        // Act

        let parsed = try? rule.parse(from: TokenStream(tokens: tokens))

        // Assert

        guard let result = parsed else {
            XCTFail("Rule must return not nil value")
            return
        }

        XCTAssertEqual(result.debugView, stringView)
    }
}
