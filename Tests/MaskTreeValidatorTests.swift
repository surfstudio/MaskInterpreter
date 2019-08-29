import Foundation
import XCTest

@testable import MaskInterpreter

public class MaskTreeValidatorTests: XCTestCase {

    // MARK: - Assert Successed

    public func testQiwiRegexpsValidateSuccess() {
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
        let validator = MaskTreeValidator()

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

        let result = values.reduce(into: true, { $0 = $0 && validator.validate(maskNode: $1) })

        // Assert

        XCTAssertTrue(result)
    }

    // MARK: - Assert Failed

    public func testBadRegexpNotParse() {
        // Arrange

        let regexp = "<!^a+d+${20}>"

        let builder = ASTBuilder()
        let validator = MaskTreeValidator()

        // Act

        let maskNode = try? builder.parse(mask: regexp)

        guard let node = maskNode else {
            XCTFail("Regexp not parse")
            return
        }

        let result = validator.validate(maskNode: node)

        // Assert

        XCTAssertFalse(result)
    }
}
