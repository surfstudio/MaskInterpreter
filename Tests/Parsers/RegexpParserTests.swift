import Foundation
import XCTest

@testable import MaskInterpreter

extension Token {
    var tokenIndex: String {
        switch self {
        case .constantSymbol(let smb):
            return "CS(\(smb))"
        case .specialSymbol(let smb):
            return "SS(\(smb.rawValue))"
        case .repeaterSymbol(let smb):
            return "RS(\(smb.rawValue))"
        case .regexpStartSymbol:
            return "RSS"
        case .regexpEndSymbol:
            return "RES"
        case .sliceSymbol:
            return "SLS"
        case .oneOfStartSymbol:
            return "OOSS"
        case .oneOfEndSymbol:
            return "OOES"
        case .regexpMeta(let min, let max):
            var expr = "RM(\(min)"
            if let max = max {
                expr += ",\(max)"
            }
            return expr + ")"
        }
    }
}

public class RegexpParserTests: XCTestCase {

    /// Считывает файл с регэкспами от киви и прогоняет каждый через парсер
    public func testQIWIRegexpFile() {

        // Arrange

        guard let url = Bundle(for: type(of: self)).url(forResource: "qiwi_regexp", withExtension: "txt") else {
            XCTFail("Cant load qiwi_regexp.txt")
            return
        }

        guard let string = try? String(contentsOf: url) else {
            XCTFail("Cant read qiwi_regexp.txt")
            return
        }

        let parser = RegexpParser()

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

    /// Проверяет что размеченые регэкспы парсятся
    public func testMarkedQIWIRegexp() {
        // Arrange

        guard let url = Bundle(for: type(of: self)).url(forResource: "marked_qiwi_regexp", withExtension: "txt") else {
            XCTFail("Cant load marked_qiwi_regexp.txt")
            return
        }

        guard let string = try? String(contentsOf: url) else {
            XCTFail("Cant read marked_qiwi_regexp.txt")
            return
        }

        let parser = RegexpParser()

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

        let regexp = "<!^[0-9]>"
        let parser = RegexpParser()

        // Act - Assert

        XCTAssertThrowsError(try parser.parse(from: CharStream(string: regexp)))
    }
}
