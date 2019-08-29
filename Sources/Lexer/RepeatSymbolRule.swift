import Foundation

/// regexpRepeatSymbolRule = (regexpOneOfRule | regexpSymbolRule) REPEATER_SYMBOL
final class RepeatSymbolRule {

    private lazy var symbolRule = SymbolRule()
    private lazy var oneOfRule = OneOfRule()

    func parse(from stream: TokenStream) throws -> ASTNode? {

        let start = stream.position

        let nextNode = {
            return try self.oneOfRule.parse(from: stream) ?? self.symbolRule.parse(from: stream)
        }

        guard let node = try nextNode() else {
            stream.position = start
            return nil
        }

        guard let token = stream.current(),
            case Token.repeaterSymbol(_) = token
        else {
            stream.position = start
            return nil
        }

        stream.pop()

        return RepeatTokenTreeNode(token: token, repeated: node)
    }
}
