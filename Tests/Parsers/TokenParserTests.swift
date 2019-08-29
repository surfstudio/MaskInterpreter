import Foundation
import XCTest

@testable import MaskInterpreter

public class TokenParserTests: XCTestCase {

    public func testQIWIMasksParsing() {

        // Arrange

        guard let url = Bundle(for: type(of: self)).url(forResource: "all_qiwi_masks", withExtension: "txt") else {
            XCTFail("Cant load all_qiwi_masks.txt")
            return
        }

        guard let string = try? String(contentsOf: url) else {
            XCTFail("Cant read all_qiwi_masks.txt")
            return
        }

        let parser = TokenParser()

        let regexps = string.split(separator: "\n").map { String($0).replacingOccurrences(of: "\\\\", with: "\\") }

        // Act

        var results = [String: [Token]?]()

        let values = regexps.compactMap { item -> [Token]? in
            guard let tokens = try? parser.parse(from: CharStream(string: item)) else {
                results[item] = nil
                return nil
            }
            results[item] = tokens
            return tokens
        }

        // Assert

        XCTAssertEqual(regexps.count, values.count)

        for index in 0..<regexps.count {
            let value = values[index]
            XCTAssertEqual(regexps[index], value.reduce(into: "", { $0 += $1.rawView }) )
        }
    }

    /// Проверяет что размеченые маски парсятся
    public func testMarkedQIWIMasksParsed() {
        // Arrange

        guard let url = Bundle(for: type(of: self)).url(forResource: "marked_qiwi_masks", withExtension: "txt") else {
            XCTFail("Cant load marked_qiwi_masks.txt")
            return
        }

        guard let string = try? String(contentsOf: url) else {
            XCTFail("Cant read marked_qiwi_masks.txt")
            return
        }

        let parser = TokenParser()

        let lines = string.split(separator: "\n").map { String($0).replacingOccurrences(of: "\\\\", with: "\\") }

        let regexps = lines.reduce(into: [String]()) { ( lhs: inout [String], rhs: String) in
            let rhs = rhs.split(separator: "@").map { String($0) }
            lhs.append(rhs[0])
        }

        let marks = lines.reduce(into: [String]()) { ( lhs: inout [String], rhs: String) in
            let rhs = rhs.split(separator: "@").map { String($0) }
            lhs.append(rhs[1])
        }

        // Act

        var results = [String: [Token]?]()

        let values = regexps.compactMap { item -> [Token]? in
            guard let tokens = try? parser.parse(from: CharStream(string: item)) else {
                results[item] = nil
                return nil
            }
            results[item] = tokens
            return tokens
        }

        // Assert

        XCTAssertEqual(regexps.count, values.count)

        for index in 0..<regexps.count {
            let value = values[index]
            XCTAssertEqual(marks[index],
                           String(value.reduce(into: "", { $0 += $1.tokenIndex + " " }).dropLast()) )
        }
    }

    /// Проверяет, что парсер упадет если нет мета символа
    public func testThatParserFailWithoutMeta() {

        // Arrange

        let regexp = "+<!^[0-9]> (<!^[0-9]+${3}>) <!^[0-9]+${3}>-<!^[0-9]+${2}>-<!^[0-9]+${2}>"
        let parser = TokenParser()

        // Act - Assert

        XCTAssertThrowsError(try parser.parse(from: CharStream(string: regexp)))
    }
}
