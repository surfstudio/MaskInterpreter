import Foundation

public final class RepeatTokenTreeNode: ASTNode {

    public let repeated: ASTNode
    public let token: Token

    public var next: [ASTNode] {
        return [self.repeated]
    }

    /// Всегда `ASTToken.repeater`
    public var nodeToken: ASTToken {
        return .repeater
    }

    public var rawView: String {
        return self.repeated.rawView + self.token.rawView
    }

    public var debugView: String {
        let bodyString = self.next.reduce(into: "", { $0 += $1.debugView + "," })
        return DebugTokens.repeatTokens(self.token.rawView) + "[\(String(bodyString.dropLast()))]"
    }

    public init(token: Token, repeated: ASTNode) {
        self.repeated = repeated
        self.token = token
    }
}
