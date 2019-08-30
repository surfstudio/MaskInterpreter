import Foundation

public struct InterpretedMask {

    public enum InputType {
        case phone
        case email
        case onlyNumbers
        case undefined
    }

    public let generated: GeneratedMask
    public let type: InputType
}

public final class MaskInterpreter {
    private lazy var builder = ASTBuilder()
    private lazy var maskGenerator = MaskGenerator()

    public init() { }

    public func intrepret(rawMask: String) throws -> InterpretedMask {
        let maskNode = try builder.parse(mask: rawMask)
        let mask = try self.maskGenerator.generate(from: maskNode)
        let type = self.getMeta(from: mask)
        return .init(generated: mask, type: type)
    }
}

private extension MaskInterpreter {

    func getMeta(from generated: GeneratedMask) -> InterpretedMask.InputType {

        let union = generated.notations.map { $0.set }.reduce(into: CharacterSet(), { $0 = $0.union($1) })

        if union == SpecialSymbolType.number.characterSet || union == GeneratorConstants.arabicNumbersSet {
            if generated.mask.first == "+" || generated.mask.first == "8" {
                return  .phone
            }
            return  .onlyNumbers
        }

        if union.contains("@") {
            return .email
        }

        return .undefined
    }
}
