import Foundation

public enum CommonIntrepreterError: Error {
    case cantUseThisNode
}

public final class RegExpExpressionTreeNode: ASTNode {

    public var min: Int
    public var max: Int?

    public var next: [ASTNode]

    /// Всегда `Token.regexpStartSymbol`
    public var token: Token {
        return Token.regexpStartSymbol
    }

    /// Всегда `ASTToken.mask`
    public var nodeToken: ASTToken {
        return .regexp
    }

    public var rawView: String {
        return Token.regexpStartSymbol.rawView +
            self.next.reduce(into: "", { $0 += $1.rawView }) +
            Token.regexpMeta(self.min, self.max).rawView +
            Token.regexpEndSymbol.rawView
    }

    public var debugView: String {
        let bodyString = self.next.reduce(into: "", { $0 += $1.debugView + "," })

        let str = DebugTokens.regexp(self.min, self.max)

        guard !bodyString.isEmpty else {
            return str
        }

        return str + "[\(String(bodyString.dropLast()))]"
    }

    public init(min: Int, max: Int?, body: [ASTNode]) {
        self.min = min
        self.max = max

        self.next = body
    }
}
