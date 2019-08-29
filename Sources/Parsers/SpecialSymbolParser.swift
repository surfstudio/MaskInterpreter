import Foundation

/// Парсит спецсимволы (зарезервированные экранированный символы, например\d)
/// SeeAlso:
///     - `Token.specialSymbol`
final class SpecialSymbolsParser {

    func parse(from stream: CharStream) -> Token? {

        guard
            stream.current() == Token.specialSymbolConst,
            stream.next() != Token.specialSymbolConst,
            let current = stream.current(),
            let next = stream.next()
        else {
            return nil
        }

        let str = String([current, next])

        guard let type = SpecialSymbolType(rawValue: str) else {
            return nil
        }

        stream.pop()
        stream.pop()

        return .specialSymbol(type)
    }
}
