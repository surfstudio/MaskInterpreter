import Foundation
import XCTest

@testable import MaskInterpreter

public class SliceGeneratorTests: XCTestCase {

    /// Проверяет что слайс из 2х символов генерирует правильное множество символов
    public func testTwoSimbolsMakeRightSet() {
        // Arrange

        let node = SliceTreeNode(left: .init(symbol: "A"), right: .init(symbol: "B"))
        let generator = SliceGenerator()

        // Act

        let result = try! generator.generate(from: node)

        // Assert

        XCTAssertEqual(result, CharacterSet(charactersIn: "AB"))
    }

    /// Проверяет что слайс из большого числа символов символов генерирует правильное множество символов
    public func testManySimbolsMakeRightSet() {
        // Arrange

        let node = SliceTreeNode(left: .init(symbol: "1"), right: .init(symbol: "9"))
        let generator = SliceGenerator()

        // Act

        let result = try! generator.generate(from: node)

        // Assert

        XCTAssertEqual(result, CharacterSet(charactersIn: "123456789"))
    }

    public func testAlphabetSymbolsMakeRightSet() {
        // Arrange

        let node = SliceTreeNode(left: .init(symbol: "А"), right: .init(symbol: "Я"))
        let generator = SliceGenerator()

        // Act

        let result = try! generator.generate(from: node)

        // Assert

        XCTAssertEqual(result, CharacterSet(charactersIn: "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"))
    }
}
