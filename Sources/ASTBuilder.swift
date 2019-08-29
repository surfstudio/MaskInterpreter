import Foundation

public final class ASTBuilder {
    private lazy var parser = TokenParser()
    private lazy var lexer = MaskExpressionRule()

    public func parse(mask: String) throws -> MaskExpressionTokenNode {
        let stream = CharStream(string: mask)

        let tokens = try self.parser.parse(from: stream)

        let tokenStream = TokenStream(tokens: tokens)

        return try self.lexer.parse(from: tokenStream)
    }
}
