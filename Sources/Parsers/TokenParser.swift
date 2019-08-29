import Foundation

/// Первый парсер в ерархии парсеров.
/// Его задача заключается в том, чтобы парсить все, что не является regexp (константы, которые пользователю вводить не нужно)
/// И определять, что начался регэксп, после триггера - передает управление парсеру регэкспов.
final class TokenParser {

    // MARK: - Private Properties

    private lazy var regexpParser = RegexpParser()

    // MARK: - Public methods

    func parse(from stream: CharStream) throws -> [Token] {
        var tokens = [Token]()

        while let current = stream.current() {
            switch current {
            case Token.regexpStartSymbolConst: //regexpStartSymbol
                guard let regexpTokens = try self.regexpParser.parse(from: stream) else {
                    fallthrough
                }
                tokens.append(contentsOf: regexpTokens)
            default: // constantSymbol
                tokens.append(.constantSymbol(current))
                stream.pop()
            }
        }
        return tokens
    }
}
