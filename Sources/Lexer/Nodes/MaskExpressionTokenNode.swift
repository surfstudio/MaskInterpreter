import Foundation

public final class MaskExpressionTokenNode: ASTNode {

    public var next: [ASTNode]

    public init(body: [ASTNode]) {
        self.next = body
    }

    /// Костыль.
    /// Всегда `Token.constantSymbol(1)`
    public var token: Token {
        return .constantSymbol("1")
    }

    /// Всегда `ASTToken.mask`
    public var nodeToken: ASTToken {
        return .mask
    }

    public var rawView: String {
        return self.next.reduce(into: "", { $0 += $1.rawView })
    }

    public var debugView: String {
        let bodyString = self.next.reduce(into: "", { $0 += $1.debugView + "," })
        return DebugTokens.mask + "[\(String(bodyString.dropLast()))]"
    }
}
