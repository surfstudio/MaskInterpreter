import Foundation

/// Нотация для описания регэкспа.
public struct RegexpMaskNotation {
    /// Минимальное кол-во символов в регулярном выражении.
    public let min: Int
    /// Максимальное кол-во символов в регулярном выражении. В случае, если nil, то размер ограничен жестко
    /// т.е. кол-во символов не больше и не меньше `min`
    public let max: Int?
    /// Массив всех отдельных множеств допустимых символов, которые требует именовать.
    public let sets: [RegExpSet]
}

/// Множество символов с модификатором "Может ли повторяться"
public struct RegExpSet {
    public let set: CharacterSet
    public let repeated: Bool
}

/// Генерирует массив `CharacterSet`-ов, которые ипользуются в "регулярке"
///
/// SeeAlso:
/// - `RepeatGenerator`
/// - `OneOfGenerator`
/// - `RegExpExpressionTreeNode`
/// - `RegexpMaskNotation`
/// - `RepeatTokenTreeNode`
/// - `ConstantSymbolNode`
/// - `SpecialSymbolNode`
public final class RegexpGenerator {

    private lazy var repeatGenerator = RepeatGenerator()
    private lazy var oneOfGenerator = OneOfGenerator()

    /// Генерирует массив `CharacterSet`-ов, которые ипользуются в "регулярке"
    /// - Parameter node: Узел для генерации.
    ///     - `GeneratorError.cantMatchThisNode`
    ///     - `GeneratorError.inconsistensyState`
    ///     - `SliceGeneratorError.sliceChildContainMoreThatOneUniceScalar`
    ///     - `SliceGeneratorError.characterHasNoOneScalar`
    public func generate(from node: RegExpExpressionTreeNode) throws -> RegexpMaskNotation {

        var sets = [RegExpSet]()

        for item in node.next {
            let set = try self.process(node: item)
            sets.append(set)
        }

        return .init(min: node.min, max: node.max, sets: sets)
    }
}

private extension RegexpGenerator {

    func process(node: ASTNode) throws -> RegExpSet {
        switch node.nodeToken {
        case .repeater:
            guard let repeater = node as? RepeatTokenTreeNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.repeater`")
            }
            return .init(set: try self.repeatGenerator.generate(from: repeater), repeated: true)
        case .oneOf:
            guard let oneOf = node as? OneOfTreeNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.oneOf`")
            }
            return .init(set: try self.oneOfGenerator.generate(from: oneOf), repeated: false)
        case .constantSymbol:
            guard let constNode = node as? ConstantSymbolNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.constantSymbol`")
            }
            return .init(set: CharacterSet(charactersIn: "\(constNode.symbol)"), repeated: false)
        case .specialSymbol:
            guard let specialNode = node as? SpecialSymbolNode else {
                throw GeneratorError.inconsistensyState("\(node) has `.specialSymbol`")
            }
            return .init(set: specialNode.symbolType.characterSet, repeated: false)
        case .mask, .regexp, .slice:
            throw GeneratorError.cantMatchThisNode(node)
        }
    }
}
