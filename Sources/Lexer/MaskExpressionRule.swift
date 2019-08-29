import Foundation

enum MaskExpressionRuleError: Error {
    /// Появляется, в том случае, если у маски нет контента
    case maskBodyIsEmptry

    /// Возникает в случае, если мы закончили парсить контент, но стрим не закончился.
    case afterParseContentStreamNotOver
}

/// maskExpression = (ConstantSymbol | regexpExpression)+
final class MaskExpressionRule {

    private lazy var regexpExprRule = RegExpExpressionRule()

    public func parse(from stream: TokenStream) throws -> MaskExpressionTokenNode {
        var nodes = [ASTNode]()

        let nextNode = { () throws -> ASTNode? in
            if let current = stream.current(),
                case Token.constantSymbol(let symbol) = current {
                stream.pop()
                return ConstantSymbolNode(symbol: symbol)
            }

            return try self.regexpExprRule.parse(from: stream)
        }

        while let node = try nextNode() {
            nodes.append(node)
        }

        guard !nodes.isEmpty else {
            throw MaskExpressionRuleError.maskBodyIsEmptry
        }

        guard stream.isEnd else {
            throw MaskExpressionRuleError.afterParseContentStreamNotOver
        }

        return MaskExpressionTokenNode(body: nodes)
    }
}
