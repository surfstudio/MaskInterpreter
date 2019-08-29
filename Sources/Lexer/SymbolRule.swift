import Foundation

/// Правило для разбора символов.
/// Умеет разбирать:
///  - `Token.constantSymbol`
///  - `Token.specialSymbol`
///
///  При этом в случае, если правило получило токен `Token.sliceToken`,
///  но следующий за ним символ - `Token.oneOfEndSymbol`,
///  то правило разберет этот токен как `Token.constantSymbol`.
///
///  ---
///  Соответствующее правило: regexpSymbolRule = SPECIAL_SYMBOL | ANY_SYMBOL | CONSTANT_SYMBOL
///  ---
///  SeeAlso:
///  - `Token.constantSymbol`
///  - `Token.specialSymbol`
///  - `Token.sliceToken`
///  - `Token.oneOfEndSymbol`
///  - `ConstantSymbolNode`
///  - `SpecialSymbolNode`
final class SymbolRule {

    func parse(from stream: TokenStream) -> ASTNode? {
        guard let token = stream.current() else {
            return nil
        }
        switch token {
        case .constantSymbol(let symbol):
            stream.pop()
            return ConstantSymbolNode(symbol: symbol)
        case .specialSymbol(let symbolType):
            stream.pop()
            return SpecialSymbolNode(symbolType: symbolType)
        case .sliceSymbol:
            guard
                let next = stream.next(),
                case Token.oneOfEndSymbol = next
            else {
                return nil
            }
            stream.pop()
            return ConstantSymbolNode(symbol: "-")
        default:
            return nil
        }
    }
}
