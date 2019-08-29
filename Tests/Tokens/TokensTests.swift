import Foundation
import XCTest

@testable import MaskInterpreter

/*
 CONSTANT_SYMBOL = .
 SPECIAL_SYMBOL = "\\d" | "\\w" | "\\s" | "\\D" | "\\W" | "\\S"
 ANY_SYMBOL = "."
 REPEATER_SYMBOL = "+" | "*"
 REGEXP_START_SYMBOL = "<!"
 REGEXP_END_SYMBOL = ">"
 SLICE_SYMBOL = "-"
 ONE_OF_START_SYMBOL = "["
 ONE_OF_END_SYMBOL = "]"
 RANGE_START_SYMBOL = "{"
 RANGE_END_SYMBOL = "}"
 RANGE_DELIMETER_SYMBOL = ","
 REGEXP_META_START_SYMBOL = "$"
 */

extension Token: Hashable {

    public static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.rawView == rhs.rawView
    }

    public var hashValue: Int {
        switch self {
        case .constantSymbol(let item):
            return item.hashValue
        case .specialSymbol(let item):
            return item.hashValue
        case .repeaterSymbol(let item):
            return item.hashValue
        default:
            return self.rawView.hashValue
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawView.hashValue)
    }
}

public class TokensTests: XCTestCase {

    private var map: [Token: String] = [
        .constantSymbol("a"): "a",
        .specialSymbol(.space): "\\s",
        .repeaterSymbol(.oneOrMore): "+",
        .regexpStartSymbol: "<!^",
        .regexpEndSymbol: ">",
        .sliceSymbol: "-",
        .oneOfStartSymbol: "[",
        .oneOfEndSymbol: "]",
        .regexpMeta(1, 2): "${1,2}",
        .regexpMeta(1, nil): "${1}"
    ]

    /// Проверяет, что токены мапятся в правильные символы
    public func testSymbolMapIsCorrect() {
        // Arrange

        let accepted = self.map.values.map { $0 }

        // Act

        let tokens = self.map.keys.map { $0.rawView }

        // Assert

        // ["${1}", "[", "<!", "\\s", "]", "+", "a", ">", "-", "${1,2}"]
        // ["${1}", "[", "<!^", "\\s", "]", "+", "a", ">", "-", "${1,2}"]

        XCTAssertEqual(accepted, tokens)
    }
}
