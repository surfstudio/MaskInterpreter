import Foundation
import XCTest

@testable import MaskInterpreter

public class MaskInterpreterTests: XCTestCase {

    /// Проверяет, что интерпритатор обрабатывает все маски
    public func testAllQiwiMasksIntrepreteSuccess() {
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

        let intrepreter = MaskInterpreter()

        // Act - Assert

        XCTAssertNoThrow(try regexps.map(intrepreter.intreprete))
    }

    /// Проверяет, что все размеченые маски разбираются правильно
    public func testMarkedMaskInterpreteSuccess() {
        // Arrange

        guard let url = Bundle(for: type(of: self)).url(forResource: "marked_regexp_for_intrepreteer", withExtension: "txt") else {
            XCTFail("Cant load marked_regexp_for_intrepreteer")
            return
        }

        guard let string = try? String(contentsOf: url) else {
            XCTFail("Cant load marked_regexp_for_intrepreteer")
            return
        }

        let lines = string.split(separator: "\n").map { String($0).replacingOccurrences(of: "\\\\", with: "\\") }

         let intrepreter = MaskInterpreter()

        let regexps = lines.reduce(into: [String]()) { ( lhs: inout [String], rhs: String) in
            let rhs = rhs.split(separator: "ƒ").map { String($0) }
            lhs.append(rhs[0])
        }

        let marks = lines.reduce(into: [String]()) { ( lhs: inout [String], rhs: String) in
            let rhs = rhs.split(separator: "ƒ").map { String($0) }
            lhs.append(rhs[1])
        }

        // Act

        let values = try! regexps.map(intrepreter.intreprete)

        // Assert

        XCTAssertEqual(regexps.count, values.count)

        for index in 0..<regexps.count {
            let value = values[index]
            XCTAssertEqual(marks[index], value.generated.mask)
        }
    }
}
