import Foundation

/// Генерирует множестов допустимых символов для `OneOfGenerator`.
/// Так же обрабатывает случай для `AnySymbol` - когда после точки стоит + или *.
///
/// SeeAlso:
/// - `OneOfGenerator`
/// - `RepeatTokenTreeNode`
/// - `ConstantSymbolNode`
/// - `OneOfTreeNode`
/// - `GeneratedConstants.anySymbolCharacterSet`
public final class RepeatGenerator {

    private lazy var oneOfGenerator = OneOfGenerator()

    /// Возвращает множестов допустимых символов для `OneOfGenerator`.
    /// - Parameter node: Узел для генерации.
    /// - Throws:
    ///     - `GeneratorError.cantMatchThisNode`
    ///     - `GeneratorError.inconsistensyState`
    ///     - `SliceGeneratorError.sliceChildContainMoreThatOneUniceScalar`
    ///     - `SliceGeneratorError.characterHasNoOneScalar`
    public func generate(from node: RepeatTokenTreeNode) throws -> CharacterSet {
        switch node.repeated.nodeToken {
        case .oneOf:
            guard let oneOfNode = node.repeated as? OneOfTreeNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.oneOf`")
            }
            return try self.oneOfGenerator.generate(from: oneOfNode)
        case .constantSymbol:
            guard let constNode = node.repeated as? ConstantSymbolNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.constantSymbol`")
            }
            // Если у нас узел повторяемый, но при этом символ - `.` то это AnySymbol.
            guard constNode.symbol == "." else {
                return CharacterSet(charactersIn: "\(constNode.symbol)")
            }
            return GeneratorConstants.anySymbolCharacterSet
        case .specialSymbol:
            guard let specialNode = node.repeated as? SpecialSymbolNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.specialSymbol`")
            }
            return specialNode.symbolType.characterSet
        case .repeater, .regexp, .slice, .mask:
            throw GeneratorError.cantMatchThisNode(node)
        }
    }
}
