import Foundation

/// Умеет парсить `Token.regexpStartSymbol`.
/// Его задача заключается в том, чтобы сказать "начался регэксп или нет".
final class RegexpStartSymbolParser {
    func parse(from stream: CharStream) -> Token? {
        guard stream.current() == Token.regexpStartSymbolConst, stream.next() == "!" else {
            return nil
        }

        let start = stream.position

        stream.pop()
        stream.pop()

        guard stream.current() == "^" else {
            stream.position = start
            return nil
        }

        stream.pop()

        return .regexpStartSymbol
    }
}
