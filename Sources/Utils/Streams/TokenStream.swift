import Foundation

/// Стрим символов.
/// Обертка над `[Token]`.
final class TokenStream {

    /// Строка, из которой стримятся символы.
    let tokens: [Token]

    /// Позиция на которой находится указатель стрима.
    var position: Int

    private let length: Int

    /// Инциаллизирует объект с помощью `[Token]`.
    /// При этом значение `position` - первый индекс строки.
    /// - Parameter string: Строка по которой нужно запустить стрим.
    init(tokens: [Token]) {
        self.tokens = tokens
        self.position = 0
        self.length = tokens.count
    }

    /// В случае, если стрим закончился возвращает true.
    var isEnd: Bool {
        return self.position == tokens.count
    }

    var canMoveNext: Bool {
        guard !isEnd else { return false }
        return self.position + 1 < length
    }

    /// Возвращает символ, на который сейчас указывает курсор.
    /// Состояние курсора при этом не меняется.
    func current() -> Token? {
        guard !isEnd else { return nil }
        return self.tokens[position]
    }

    /// Возвращает символ на который указывает курсор.
    /// Затем сдвигает курсор на следующую позицию.
    /// В случае, если курсор сдвинуть нельзя (он указыает на последний символ)
    /// состояние курсора не изменится.
    @discardableResult
    func pop() -> Token? {
        guard !isEnd else { return nil }

        let symbol = self.tokens[position]
        self.position += 1
        return symbol
    }

    /// Возвращает следюущий символ (после того, на который указыает курсорс)
    /// Состояние курсора при этом не меняется.
    func next() -> Token? {
        guard self.canMoveNext else { return nil }
        return self.tokens[self.position + 1]
    }
}
