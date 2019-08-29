import Foundation

/// Типы специальных символов, которые поддерживает токен
///
/// - space: Символ пробела
/// - notSpace: Все что угодно, но не символ пробела или табуляции.
/// - word: Слово (буквы, цифры, знак подчеркивания)
/// - notWord: Все что не слово.
/// - number: Любая цифра.
/// - notNumber: Все что не цифра.
/// - anySymbol: Любой символ кроме перевода строки.
public enum SpecialSymbolType: String {
    case space = "\\s"
    case notSpace = "\\S"
    case word = "\\w"
    case notWord = "\\W"
    case number = "\\d"
    case notNumber = "\\D"
}
