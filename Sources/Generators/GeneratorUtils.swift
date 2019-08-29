import Foundation

public enum GeneratorConstants {
    public static let anySymbolCharacterSet = CharacterSet().inverted

    /// Коллекция символов для именования обязательных CharacterSet-ов в маске.
    /// Необходимо `mask-input`.
    public static var availableMandatoryCharacters: [Character] {
        var letters = (UInt32("b")...UInt32("z")).compactMap(UnicodeScalar.init)
        letters += (UInt32("а")...UInt32("я")).compactMap(UnicodeScalar.init)
        let string = String(Substring.UnicodeScalarView(letters))
        return string.map { $0 }
    }

    /// Коллекция символов для именования необязательных CharacterSet-ов в маске.
    /// Необходимо `mask-input`.
    public static var availableOptionalCharacters: [Character] {
        var letters = (UInt32("B")...UInt32("Z")).compactMap(UnicodeScalar.init)
        letters += (UInt32("А")...UInt32("Я")).compactMap(UnicodeScalar.init)
        let string = String(Substring.UnicodeScalarView(letters))
        return string.map { $0 }
    }

    public static let arabicNumbersSet: CharacterSet = CharacterSet(charactersIn: "0123456789")
}

public extension SpecialSymbolType {
    var characterSet: CharacterSet {
        switch self {
        case .space:
            return .whitespacesAndNewlines
        case .notSpace:
            return SpecialSymbolType.space.characterSet.inverted
        case .word:
            return .alphanumerics
        case .notWord:
            return SpecialSymbolType.word.characterSet.inverted
        case .number:
            return .decimalDigits
        case .notNumber:
            return SpecialSymbolType.number.characterSet.inverted
        }
    }
}
