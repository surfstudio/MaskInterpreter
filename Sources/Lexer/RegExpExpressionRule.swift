import Foundation

enum RegExpExpressionRuleError: Error {
    /// Возникает вслучае, если внутир регэкспа не было тела
    case notFoundBody

    /// Возникает в случае, если тело распарсилось, но не нашелся токен с мета-данными
    case notFoundMeta

    /// Возникает в случае, если распарсилось все, кроме токена окончания регэкспа
    case notFoundRegexpEnd
}

// regexpExpressionRule = REGEXP_START_SYMBOL regexpBodyRule+ regexpMetaRule REGEXP_END_SYMBOL
final class RegExpExpressionRule {

    private lazy var bodyRule = BodyRule()

    func parse(from stream: TokenStream) throws -> ASTNode? {
        let start = stream.position

        guard let token = stream.current(),
            case Token.regexpStartSymbol = token
        else {
            return nil
        }

        stream.pop()

        var nodes = [ASTNode]()

        while let current = try self.bodyRule.parse(from: stream) {
            nodes.append(current)
        }

        guard !nodes.isEmpty else {
            stream.position = start
            throw RegExpExpressionRuleError.notFoundBody
        }

        guard
            let meta = stream.current(),
            case Token.regexpMeta(let min, let max) = meta
        else {
            stream.position = start
            throw RegExpExpressionRuleError.notFoundMeta
        }

        stream.pop()

        guard
            let end = stream.current(),
            case Token.regexpEndSymbol = end
        else {
            stream.position = start
            throw RegExpExpressionRuleError.notFoundMeta
        }

        stream.pop()

        return RegExpExpressionTreeNode(min: min, max: max, body: nodes)
    }
}
