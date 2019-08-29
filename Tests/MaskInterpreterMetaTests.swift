import Foundation
import XCTest

@testable import MaskInterpreter

public class MaskInterpreterMetaTests: XCTestCase {

    /// Проверяет, что для простого выражения кол-во символов расчитается верно
    public func testSimbpleCountSuccess() {

        // Arrange

        let string = "8(<!^\\d+${3}>)<!^\\d+${3}>-<!^\\d+${2}>-<!^\\d+${2}>"
        let interpreter = MaskInterpreter()

        // Act

        let mask = try! interpreter.intreprete(rawMask: string)

        // Assert

        XCTAssertEqual(mask.generated.min, 15)
        XCTAssertEqual(mask.generated.max, 15)
    }

    /// Проверяет, что для сложного выражения кол-во символов расчитается верно
    public func testStrongCountSuccess() {

        // Arrange

        let string = "8(<!^\\d+${0,20}>)<!^\\d+${3,10}>-<!^\\d+${2}>-<!^\\d+${2}>"
        let interpreter = MaskInterpreter()

        // Act

        let mask = try! interpreter.intreprete(rawMask: string)

        // Assert

        XCTAssertEqual(mask.generated.min, 12)
        XCTAssertEqual(mask.generated.max, 42)
    }

    public func testInputTypePhone() {

        // Arrange

        let string = "8(<!^\\d+${3}>)<!^\\d+${3}>-<!^\\d+${2}>-<!^\\d+${2}>"
        let interpreter = MaskInterpreter()

        // Act

        let mask = try! interpreter.intreprete(rawMask: string)

        // Assert

        XCTAssertEqual(mask.type, .phone)
    }

    public func testInputTypeNumber() {

        // Arrange

        let string = "<!^\\d+${3}><!^\\d+${3}>-<!^\\d+${2}>-<!^\\d+${2}>"
        let interpreter = MaskInterpreter()

        // Act

        let mask = try! interpreter.intreprete(rawMask: string)

        // Assert

        XCTAssertEqual(mask.type, .onlyNumbers)
    }

    public func testInputTypeEmail() {

        // Arrange

        let string = "<!^[0-9A-Za-z_.@-]+${1,55}>"
        let interpreter = MaskInterpreter()

        // Act

        let mask = try! interpreter.intreprete(rawMask: string)

        // Assert

        XCTAssertEqual(mask.type, .email)
    }

    public func testInputTypeDefault() {

        // Arrange

        let string = "<!^[a-zA-Z0-9_]+${3,15}>"
        let interpreter = MaskInterpreter()

        // Act

        let mask = try! interpreter.intreprete(rawMask: string)

        // Assert

        XCTAssertEqual(mask.type, .undefined)
    }
}
