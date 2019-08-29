import Foundation

enum DebugTokens {

    public static let mask = "MASK()"
    public static let oneOf = "OO()"
    public static let slice = "SL()"

    public static func constSymbl(_ char: Character) -> String {
        return "CS(\(char))"
    }

    public static func specialSymbl(_ symbol: SpecialSymbolType) -> String {
        return "SS(\(symbol.rawValue))"
    }

    public static func repeatTokens(_ symbol: String) -> String {
        return "RT(\(symbol))"
    }

    public static func error(_ token: Token) -> String {
        return "ERROR \(token)"
    }

    public static func regexp(_ min: Int, _ max: Int?) -> String {
        var str = "RE(\(min)"

        if let max = max {
            str += ",\(max)"
        }

        return str + ")"
    }
}
