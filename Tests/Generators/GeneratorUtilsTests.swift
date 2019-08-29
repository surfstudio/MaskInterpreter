import Foundation
import XCTest

@testable import MaskInterpreter

public class GeneratorUtilsTests: XCTestCase {

    /// Проверяет, что `GeneratedConstants.availableMandatoryCharacters` и
    /// `GeneratedConstants.availableOptionalCharacters` не имеют общих символов
    public func testResevedMandatoryAndOptionsSymbolsHasNoIntersections() {

        // Arrange

        let mandatory = GeneratorConstants.availableMandatoryCharacters
        let optional = GeneratorConstants.availableOptionalCharacters

        // Act

        let sm = mandatory.sorted()
        let so = optional.sorted()

        // Assert

        XCTAssertNotEqual(sm, so)
    }
}
