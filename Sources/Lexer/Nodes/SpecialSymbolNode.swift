import Foundation

/// Узел для специального символа.
/// 
/// SeeAlso:
///  - `Token.specialSymbol`
///  - `ASTToken.specialSymbol`
final class SpecialSymbolNode: ASTNode {

    /// Всегда пустой массив,
    /// потому что у специального символа не может быть потомков
    var next: [ASTNode] {
        return []
    }

    /// Всегда `Token.specialSymbol`
    var token: Token {
        return .specialSymbol(self.symbolType)
    }

    /// Всегда `ASTToken.specialSymbol`
    var nodeToken: ASTToken {
        return .specialSymbol
    }

    let symbolType: SpecialSymbolType

    init(symbolType: SpecialSymbolType) {
        self.symbolType = symbolType
    }

    var rawView: String {
        return self.token.rawView
    }

    var debugView: String {
        return DebugTokens.specialSymbl(self.symbolType)
    }
}
