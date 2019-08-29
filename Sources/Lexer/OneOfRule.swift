import Foundation

enum OneOfRuleError: Error {
    /// Ожидалось, что после начала правила (после `[`) будут другие правила
    case awaitingSymbolsButNotFound

    /// Ожидалось, что будет символ конца правила `]`,
    /// однако он не был найден.
    case awaitingEndRuleSymbol
}

/// Правило для разбора выражения `oneOf`
///
/// ---
/// Соответствующее правило: regexpOneOfRule = ONE_OF_START_SYMBOL (regexpSliceRule | regexpSymbolRule)+ ONE_OF_END_SYMBOL
///
///---
///  SeeAlso:
///  - `Token.oneOfStartSymbol`
///  - `Token.oneOfEndSymbol`
///  - `OneOfRuleError`
///  - `SliceRule`
///  - `SymbolRule`
///  - `OneOfTreeNode`
final class OneOfRule {

    private lazy var sliceRule = SliceRule()
    private lazy var symbolRule = SymbolRule()

    func parse(from stream: TokenStream) throws -> OneOfTreeNode? {
        guard let current = stream.current(),
            case Token.oneOfStartSymbol = current
        else {
            return nil
        }

        stream.pop()

        let getNode = {
            return self.sliceRule.parse(from: stream) ??
                self.symbolRule.parse(from: stream)
        }

        var nodes = [ASTNode]()

        while let node = getNode() {
            nodes.append(node)
        }

        guard !nodes.isEmpty else {
            throw OneOfRuleError.awaitingSymbolsButNotFound
        }

        guard let end = stream.current(),
            case Token.oneOfEndSymbol = end
        else {
            throw OneOfRuleError.awaitingEndRuleSymbol
        }

        stream.pop()

        return OneOfTreeNode(next: nodes)
    }
}
