import Foundation
import XCTest

@testable import MaskInterpreter

public class ASTBuilderTests: XCTestCase {

    public func testOnAllQiwiMasks() {
        // Arrange

        guard let url = Bundle(for: type(of: self)).url(forResource: "all_qiwi_masks", withExtension: "txt") else {
            XCTFail("Cant load all_qiwi_masks.txt")
            return
        }

        guard let string = try? String(contentsOf: url) else {
            XCTFail("Cant read all_qiwi_masks.txt")
            return
        }

        let regexps = string.split(separator: "\n").map { String($0).replacingOccurrences(of: "\\\\", with: "\\") }
        let builder = ASTBuilder()

        // Act

        var values = [MaskExpressionTokenNode]()
        var mask = ""

        do {
            values = try regexps.compactMap { item in
                do {
                    return try builder.parse(mask: item)
                } catch {
                    mask = item
                    throw error
                }
            }
        } catch {
            XCTFail("\(error) mask: \(mask)")
            return
        }

        // Assert

        XCTAssertEqual(regexps.count, values.count)

        for index in 0..<regexps.count {
            let value = values[index]
            XCTAssertEqual(regexps[index], value.rawView )
        }
    }

    public func testBadMask() {

        // Arrange

        let mask = "<!^[0-9A-Za-z_.@-]+${1,55}>"
        let builder = ASTBuilder()

        // Act

        let node = try? builder.parse(mask: mask)

        // Assert

        XCTAssertEqual(node?.rawView, mask)
    }

    public func testMarkedQuiwiMasks() {
        // Arrange

        guard let url = Bundle(for: type(of: self)).url(forResource: "marked_to_tree_qiwi_masks", withExtension: "txt") else {
            XCTFail("Cant load marked_to_tree_qiwi_masks")
            return
        }

        guard let string = try? String(contentsOf: url) else {
            XCTFail("Cant read marked_to_tree_qiwi_masks")
            return
        }

        let lines = string.split(separator: "\n").map { String($0).replacingOccurrences(of: "\\\\", with: "\\") }
        let builder = ASTBuilder()

        let regexps = lines.reduce(into: [String]()) { ( lhs: inout [String], rhs: String) in
            let rhs = rhs.split(separator: "ƒ").map { String($0) }
            lhs.append(rhs[0])
        }

        let marks = lines.reduce(into: [String]()) { ( lhs: inout [String], rhs: String) in
            let rhs = rhs.split(separator: "ƒ").map { String($0) }
            lhs.append(rhs[1])
        }

        // Act

        var values = [MaskExpressionTokenNode]()
        var mask = ""

        do {
            values = try regexps.compactMap { item in
                do {
                    return try builder.parse(mask: item)
                } catch {
                    mask = item
                    throw error
                }
            }
        } catch {
            XCTFail("\(error) mask: \(mask)")
            return
        }

        // Assert

        XCTAssertEqual(regexps.count, values.count)

        for index in 0..<regexps.count {
            let value = values[index]
            XCTAssertEqual(marks[index], value.debugView )
        }
    }
}

/**
 MaskExpression: MASK()[...]
 RegExpExpression: RE(min,max?)[...]
 Slice: SL()[...]
 OneOf: OO() [...]
 RepeatSymbol: RT(+ | *) [...]
 ConstantSymbol: CS($SYMBOL$)
 SpecialSymbol: SS(\\d|\\D...)
 */
