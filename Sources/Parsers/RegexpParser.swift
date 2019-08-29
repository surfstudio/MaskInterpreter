import Foundation

enum RegexpParserError: Error {
    case metaStartSymbolOnUnexpectedPosition
    case notFoundRegexpEndSymbol
}

/// Второй по уровнб вложенности парсер.
/// Его вызывает `TokenParser`.
/// Задача этого парсера - распарсить "регэксп"
/// SeeAlso:
///     - `TokenParser`
final class RegexpParser {

    // MARK: - Private Properties

    private lazy var specialSymbolParser = SpecialSymbolsParser()
    private lazy var regexpStartSymbolParser = RegexpStartSymbolParser()
    private lazy var regexpMetaParser = RegexpMetaParser()
    private lazy var oneOfTokenParser = OneOfTokenParser()

    // MARK: - Public Methods

    // swiftlint:disable:next cyclomatic_complexity
    func parse(from stream: CharStream) throws -> [Token]? {

        let start = stream.position

        guard let regexpStart = regexpStartSymbolParser.parse(from: stream) else {
            return nil
        }

        var tokens = [regexpStart]
        var hasMeta = false

        while let current = stream.current() {
            switch current {
            case Token.specialSymbolConst: // specialSymbol
                if let token = self.specialSymbolParser.parse(from: stream) {
                    tokens.append(token)
                } else { // constantSymbol
                    tokens.append(.constantSymbol(current))
                    stream.pop()
                    if let next = stream.current() {
                        tokens.append(.constantSymbol(next))
                        stream.pop()
                    }
                }
            case "+": // repeaterSymbol
                tokens.append(.repeaterSymbol(.oneOrMore))
                stream.pop()
            case "*": // repeaterSymbol
                tokens.append(.repeaterSymbol(.zeroOrMore))
                stream.pop()
            case Token.regexpEndSymbolConst: // regexpEndSymbol
                guard hasMeta else {
                    stream.position = start
                    throw RegexpParserError.notFoundRegexpEndSymbol
                }
                tokens.append(.regexpEndSymbol)
                stream.pop()
                return tokens
            case Token.regexpMetaConst:
                guard let token = try self.regexpMetaParser.parse(from: stream) else {
                    stream.position = start
                    throw RegexpParserError.metaStartSymbolOnUnexpectedPosition
                }
                tokens.append(token)
                hasMeta = true
            case Token.oneOfStartSymbolConst:
                guard let result = try self.oneOfTokenParser.parse(from: stream) else {
                    fallthrough
                }
                tokens.append(contentsOf: result)
            default: // constantSymbol
                tokens.append(.constantSymbol(current))
                stream.pop()
            }
        }
        stream.position = start
        throw RegexpParserError.notFoundRegexpEndSymbol
    }
}
