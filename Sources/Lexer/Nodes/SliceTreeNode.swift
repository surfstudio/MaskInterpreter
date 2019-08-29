import Foundation

/// Узел для описания правила `slice`
/// Может содержать только два потомка `ConstantSymbolNode`
/// 
/// SeeAlso:
/// - `Token.sliceSymbol`
/// - `ASTToken.slice`
/// - `ConstantSymbolNode`
/// - `SliceRule`
public final class SliceTreeNode: ASTNode {

    /// Всегда `Token.sliceSymbol`
    public var token: Token {
        return .sliceSymbol
    }

    /// Всегда `ASTToken.slice`
    public var nodeToken: ASTToken {
        return .slice
    }

    /// Возвращает правого и левого потомка.
    /// Больше потомков у этого узла быть не может.
    public var next: [ASTNode] {
        return [self.left, self.right]
    }

    public let left: ConstantSymbolNode
    public let right: ConstantSymbolNode

    public var rawView: String {
        return self.left.rawView + self.token.rawView + self.right.rawView
    }

    public var debugView: String {
        let bodyString = self.next.reduce(into: "", { $0 += $1.debugView + "," })
        return DebugTokens.slice + "[\(String(bodyString.dropLast()))]"
    }

    public init(left: ConstantSymbolNode, right: ConstantSymbolNode) {
        self.left = left
        self.right = right
    }
}
