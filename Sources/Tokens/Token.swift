import Foundation

/// Содержит все токены
/// - constantSymbol = CONSTANT_SYMBOL
/// - specialSymbol = SPECIAL_SYMBOL
/// - anySymbol = ANY_SYMBOL
/// - repeaterSymbol = REPEATER_SYMBOL
/// - regexpStartSymbol = REGEXP_START_SYMBOL
/// - regexpEndSymbol = REGEXP_END_SYMBOL
/// - sliceSymbol = SLICE_SYMBOL
/// - oneOfStartSymbol = ONE_OF_START_SYMBOL
/// - oneOfEndSymbol = ONE_OF_END_SYMBOL
/// - rangeStartSymbol = RANGE_START_SYMBOL
/// - rangeEndSymbol = RANGE_END_SYMBOL
/// - rangeDelimeterSymbol = RANGE_DELIMETER_SYMBOL
/// - regexpMetaStartSymbol = REGEXP_META_START_SYMBOL
public enum Token {

    // MARK: - Const

    public static var specialSymbolConst: Character = "\\"
    public static var regexpStartSymbolConst: Character = "<"
    public static var regexpEndSymbolConst: Character = ">"
    public static var sliceSymbolConst: Character = "-"
    public static var oneOfStartSymbolConst: Character = "["
    public static var oneOfEndSymbolConst: Character = "]"
    public static var regexpMetaConst: Character = "$"

    // MARK: - Cases

    case constantSymbol(Character)
    case specialSymbol(SpecialSymbolType)
    case repeaterSymbol(RepeaterSymbolType)
    case regexpStartSymbol
    case regexpEndSymbol
    case sliceSymbol
    case oneOfStartSymbol
    case oneOfEndSymbol
    case regexpMeta(Int, Int?)

    // MARK: - Clculated Properties

    /// Представление токена в QIWI-формате
    /// Т.Е. как выглядел этот токен до парсинга
    public var rawView: String {
        switch self {
        case .constantSymbol(let symbol):
            return "\(symbol)"
        case .specialSymbol(let symbol):
            return "\(symbol.rawValue)"
        case .repeaterSymbol(let symbol):
            return "\(symbol.rawValue)"
        case .regexpStartSymbol:
            return "<!^"
        case .regexpEndSymbol:
            return ">"
        case .sliceSymbol:
            return "-"
        case .oneOfStartSymbol:
            return "["
        case .oneOfEndSymbol:
            return "]"
        case .regexpMeta(let min, let max):
            var expr = "${\(min)"
            if let max = max {
                expr += ",\(max)"
            }
            return expr + "}"
        }
    }

    /// Содержит управляющие константы
    /// - WARNING: Используется только для того, чтобы хранить именованые константы для свичей в парсере
    public var const: Character {
        switch self {
        case .constantSymbol(_):
            return "\0"
        case .specialSymbol(_):
            return "\\"
        case .repeaterSymbol(_):
            return "\0"
        case .regexpStartSymbol:
            return "<"
        case .regexpEndSymbol:
            return ">"
        case .sliceSymbol:
            return "-"
        case .oneOfStartSymbol:
            return "["
        case .oneOfEndSymbol:
            return "]"
        case .regexpMeta(_, _):
            return "$"
        }
    }
}
