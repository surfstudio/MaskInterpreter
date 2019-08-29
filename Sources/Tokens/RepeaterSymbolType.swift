import Foundation

/// Типы символов для повторения предыдущих токенов.
/// - oneOrMore: Один или более раз.
/// - zeroOrMore: 0 либо более раз.
public enum RepeaterSymbolType: Character {
    case oneOrMore = "+"
    case zeroOrMore = "*"
}
