import Foundation

/// Используется для получения `CharacterSet` допустимых символов из `OneOfTreeNode`
///
/// Умете обрабатывать только:
/// - `ASTToken.constantSymbol`
/// - `ASTToken.specialSymbol`
/// - `ASTToken.slice`
/// -----
/// SeeAlso:
/// - `OneOfTreeNode`
/// - `ASTToken.constantSymbol`
/// - `ASTToken.specialSymbol`
/// - `ASTToken.slice`
/// - `SLiceGenerator`
public final class OneOfGenerator {

    private lazy var sliceGenerator = SliceGenerator()

    /// Возвращает множество допустимых символов.
    /// - Parameter node: Узел для генерации.
    /// - Throws:
    ///     - `GeneratorError.cantMatchThisNode`
    ///     - `GeneratorError.inconsistensyState`
    ///     - `SliceGeneratorError.sliceChildContainMoreThatOneUniceScalar`
    ///     - `SliceGeneratorError.characterHasNoOneScalar`
    public func generate(from node: OneOfTreeNode) throws -> CharacterSet {

        var resultSet = CharacterSet()

        for item in node.next {
            let set = try self.process(node: item)
            resultSet = resultSet.union(set)
        }

        return resultSet
    }
}

private extension OneOfGenerator {
    func process(node: ASTNode) throws -> CharacterSet {
        switch node.nodeToken {
        case .constantSymbol:
            guard let constNode = node as? ConstantSymbolNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.constantSymbol`")
            }
            return CharacterSet(charactersIn: "\(constNode.symbol)")
        case .specialSymbol:
            guard let specialNode = node as? SpecialSymbolNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.specialSymbol`")
            }
            return specialNode.symbolType.characterSet
        case .slice:
            guard let sliceNode = node as? SliceTreeNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.slice`")
            }
            return try self.sliceGenerator.generate(from: sliceNode)
        case .repeater, .regexp, .mask, .oneOf:
            throw GeneratorError.cantMatchThisNode(node)
        }
    }
}
