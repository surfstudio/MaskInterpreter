import Foundation

enum ParseMetaError: Error {
    case cantParseMinAsInt
    case cantParseMaxAsInt
}

/// Этот парсер отвечает за то, чтобы распарсить метаданные о регэкспе
/// (выражение в конце регэкспа ${n,m})
/// SeeAlso:
///     - `Token.regexpMeta`
final class RegexpMetaParser {

    func parse(from stream: CharStream) throws -> Token? {
        guard stream.current() == Token.regexpMetaConst, stream.next() == "{" else {
            return nil
        }

        let start = stream.position

        stream.pop()
        stream.pop()

        var string = ""

        while let char = stream.current(), char != "," && char != "}" {
            string.append(char)
            stream.pop()
        }

        guard let minValue = Int(string) else {
            stream.position = start
            throw ParseMetaError.cantParseMinAsInt
        }

        if stream.current() == "}" {
            stream.pop()
            return .regexpMeta(minValue, nil)
        }

        stream.pop()
        string = ""

        while let char = stream.current(), char != "}" {
            string.append(char)
            stream.pop()
        }

        guard let maxValue = Int(string) else {
            stream.position = start
            throw ParseMetaError.cantParseMaxAsInt
        }

        stream.pop()
        return .regexpMeta(minValue, maxValue)
    }
}
