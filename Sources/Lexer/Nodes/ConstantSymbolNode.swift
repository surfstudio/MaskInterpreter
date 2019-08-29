import Foundation

/// Узел для описания константного символа.
/// 
/// SeeAlso:
/// - `Token.constantSymbol`
/// - `ASTToken.constantSymbol`
public final class ConstantSymbolNode: ASTNode {

    /// Всегда пустой массив,
    /// потому что у константного символа не может быть потомков
    public var next: [ASTNode] {
        return []
    }

    /// Всегда `Token.constantSymbol`
    public var token: Token {
        return .constantSymbol(self.symbol)
    }

    /// Всегда `ASTToken.constantSymbol`
    public var nodeToken: ASTToken {
        return .constantSymbol
    }

    public let symbol: Character

    public init(symbol: Character) {
        self.symbol = symbol
    }

    public var rawView: String {
        return self.token.rawView
    }

    public var debugView: String {
        return DebugTokens.constSymbl(self.symbol)
    }
}
