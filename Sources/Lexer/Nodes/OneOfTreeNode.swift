import Foundation

/// Узел для описания выражения `OneOf`.
///
/// SeeAlso:
/// - `Token.oneOfStartSymbol`
/// - `ASTToken.oneOf`
public final class OneOfTreeNode: ASTNode {

    public let next: [ASTNode]

    public var rawView: String {
        return self.token.rawView +
            self.next.reduce(into: "", { $0 += $1.rawView }) +
            Token.oneOfEndSymbol.rawView
    }

    public var debugView: String {
        let bodyString = self.next.reduce(into: "", { $0 += $1.debugView + "," })
        return DebugTokens.oneOf + "[\(String(bodyString.dropLast()))]"
    }

    /// Всегда `Token.oneOfStartSymbol`
    public var token: Token {
        return .oneOfStartSymbol
    }

    /// Всегда `ASTToken.oneOf`
    public var nodeToken: ASTToken {
        return .oneOf
    }

    init(next: [ASTNode]) {
        self.next = next
    }
}
