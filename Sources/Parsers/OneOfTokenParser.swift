import Foundation

enum OneOfTokenParserError: Error {
    case notFoundOneOfEndSymbol
}

/// Третий по уровню вложенности парсер. Отвечает за парсинг выражения `one of`
/// (например: [1234567])
/// Вызывается `RegexpParser`-ом.
/// SeeAlso:
///     - `RegexpParser`
final class OneOfTokenParser {

    private lazy var specialSymbolParser = SpecialSymbolsParser()

    func parse(from stream: CharStream) throws -> [Token]? {

        guard stream.current() == "[" else {
            return nil
        }

        var tokens: [Token] = [.oneOfStartSymbol]

        stream.pop()

        while let current = stream.current() {
            switch current {
            case Token.specialSymbolConst:
                if let token = self.specialSymbolParser.parse(from: stream) {
                    tokens.append(token)
                } else {

                    tokens.append(.constantSymbol(current))
                    stream.pop()

                    if let next = stream.current() {
                        tokens.append(.constantSymbol(next))
                        stream.pop()
                    }

                }
            case Token.sliceSymbolConst:
                tokens.append(.sliceSymbol)
                stream.pop()
            case Token.oneOfEndSymbolConst:
                tokens.append(.oneOfEndSymbol)
                stream.pop()
                return tokens
            default: // constantSymbol
                tokens.append(.constantSymbol(current))
                stream.pop()
            }
        }
        throw OneOfTokenParserError.notFoundOneOfEndSymbol
    }
}
