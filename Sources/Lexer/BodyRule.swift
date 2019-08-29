import Foundation

/// regexpBodyRule = regexpRepeatSymbolRule | regexpOneOfRule | regexpSymbolRule
final class BodyRule {

    private lazy var repeatSymbolRule = RepeatSymbolRule()
    private lazy var oneOfRule = OneOfRule()
    private lazy var symbolRule = SymbolRule()

    func parse(from stream: TokenStream) throws -> ASTNode? {
        return try self.repeatSymbolRule.parse(from: stream) ??
            (try self.oneOfRule.parse(from: stream)) ??
            self.symbolRule.parse(from: stream)
    }
}
