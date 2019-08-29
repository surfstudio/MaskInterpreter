import Foundation
import XCTest

@testable import MaskInterpreter

public class OneOfGeneratorTests: XCTestCase {

    // MARK: - Assert Succesed

    /// Проверяет, что простое выражение генерирует правильное множество
    public func testSimpleExpressionGenerateSuccess() {

        // Arrange

        let node = OneOfTreeNode(next: [
            ConstantSymbolNode(symbol: "1")
        ])

        let generator = OneOfGenerator()

        // Act

        let result = try! generator.generate(from: node)

        // Assert

        XCTAssertEqual(result, CharacterSet(charactersIn: "1"))
    }

    /// Проверяет, что для выражения из нескольких символов генерируется правильное множество.
    public func testGeneratorUnionSets() {

        // Arrange

        let node = OneOfTreeNode(next: [
            ConstantSymbolNode(symbol: "1"),
            ConstantSymbolNode(symbol: "2"),
            ConstantSymbolNode(symbol: "1")
        ])

        let generator = OneOfGenerator()

        // Act

        let result = try! generator.generate(from: node)
        
        // Assert

        XCTAssertEqual(result, CharacterSet(charactersIn: "12"))
    }

    // Assert Failed

    /// Проверяет, что в случае некорректного узла будет выброшено исклчение `GeneratorError.cantMatchThisNode`
    public func testCantMatchThisNodeThrows() {

        // Arrange

        let node = OneOfTreeNode(next: [
            MaskExpressionTokenNode(body: [])
        ])

        let generator = OneOfGenerator()

        // Act - Assert

        XCTAssertThrowsError(try generator.generate(from: node), "") { (error) in
            guard case GeneratorError.cantMatchThisNode(let token) = error else {
                XCTFail()
                return
            }

            XCTAssertEqual(token.nodeToken, ASTToken.mask)
        }
    }
}

