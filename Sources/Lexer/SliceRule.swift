import Foundation

/// Правило для разбора выражения `slice`.
///
/// ---
/// Соответствующее правило: regexpSliceRule = CONSTANT_SYMBOL SLICE_SYMBOL CONSTANT_SYMBOL
///
///---
/// SeeAlso:
/// - `Token.constantSymbol`
/// - `SliceTreeNode`
final class SliceRule {

    func parse(from stream: TokenStream) -> ASTNode? {

        let start = stream.position

        guard let lefySymbol = self.getConstantSymbol(from: stream),
            let current = stream.current(),
            case Token.sliceSymbol = current,
            stream.pop() != nil,
            let rightSymbol = self.getConstantSymbol(from: stream)
        else {
            stream.position = start
            return nil
        }

        return SliceTreeNode(left: ConstantSymbolNode(symbol: lefySymbol),
                             right: ConstantSymbolNode(symbol: rightSymbol))
    }
}

private extension SliceRule {
    func getConstantSymbol(from stream: TokenStream) -> Character? {
        guard let symbolToken = stream.current(),
            case Token.constantSymbol(let symbol) = symbolToken,
            stream.pop() != nil
        else {
            return nil
        }

        return symbol
    }
}
