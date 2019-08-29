import Foundation
import XCTest

@testable import MaskInterpreter

public class TokenTreeDeepWalkTests: XCTestCase {

    class TestNode: ASTNode {
        var token: Token {
            return .constantSymbol(self.symbol)
        }

        var nodeToken: ASTToken {
            return .constantSymbol
        }

        var next: [ASTNode]

        var rawView: String {
            return self.token.rawView
        }

        var debugView: String {
            return DebugTokens.constSymbl(self.symbol)
        }

        let symbol: Character

        init(symbol: Character, next: [TestNode] = []) {
            self.symbol = symbol
            self.next = next
        }
    }

    public func testDeepWalkWorkSuccess() {

        // Arrange

        let smbs: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "="]
        let root = TestNode(symbol: smbs[0], next: [
            .init(symbol: smbs[1]),
            .init(symbol: smbs[2]),
            .init(symbol: smbs[3], next: [
                .init(symbol: smbs[4]),
                .init(symbol: smbs[5]),
                .init(symbol: smbs[6], next: [
                    .init(symbol: smbs[7], next: [
                        .init(symbol: smbs[8]),
                        .init(symbol: smbs[9], next: [
                            .init(symbol: smbs[10], next: [
                                .init(symbol: smbs[11])
                            ])
                        ])
                    ])
                ])
            ])
        ])

        let tree = TokenTree(root: root)

        // Act

        var result = ""

        tree.deepWalk { result += $0.token.rawView }

        let awaiting = smbs.reduce(into: "", { $0 += "\($1)" })

        // Assert

        XCTAssertEqual(result, awaiting)
    }
}
