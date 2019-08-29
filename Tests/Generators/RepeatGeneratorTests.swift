import Foundation
import XCTest

@testable import MaskInterpreter

public class RepeatGeneratorTests: XCTestCase {

    /// Проверяет, что в простом случае репитер работает.
    /// Проверка для сложного случая с `oneOf` не требуется, так как при успехе этого теста
    /// и успехе тестов для `oneOf` еще одна проверка будет излишней.
    public func testSimpleRepeater() {

        // Arrange

        let node = RepeatTokenTreeNode(token: .repeaterSymbol(.oneOrMore),
                                       repeated: ConstantSymbolNode(symbol: "1"))

        let generator = RepeatGenerator()

        // Act

        let result = try! generator.generate(from: node)

        // Assert

        XCTAssertEqual(result, CharacterSet(charactersIn: "1"))
    }

    /// Проверяет, что множество "любой символ" действительно генерируется.
    public func testAnySymbolSetGeneratedSuccess() {

        // Arrange

        let node = RepeatTokenTreeNode(token: .repeaterSymbol(.oneOrMore),
                                       repeated: ConstantSymbolNode(symbol: "."))

        let generator = RepeatGenerator()

        // Act

        let result = try! generator.generate(from: node)

        // Assert

        XCTAssertEqual(result, GeneratorConstants.anySymbolCharacterSet)
    }
}
