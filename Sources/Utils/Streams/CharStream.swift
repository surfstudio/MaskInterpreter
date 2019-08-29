import Foundation

protocol Streamable {

}

/// Стрим символов.
/// Обертка над `String`.
final class CharStream {

    /// Строка, из которой стримятся символы.
    let string: String

    /// Позиция на которой находится указатель стрима.
    var position: String.Index

    /// Инциаллизирует объект с помощью `string`.
    /// При этом значение `position` - первый индекс строки.
    /// - Parameter string: Строка по которой нужно запустить стрим.
    init(string: String) {
        self.string = string
        self.position = string.startIndex
    }

    /// Инциаллизирует объект.
    /// - Parameter string: Строка по которой нужно запустить стрим.
    /// - Parameter position: Индекс строки с которой начнется стрим.
    init(string: String, position: String.Index) {
        self.string = string
        self.position = position
    }

    /// В случае, если стрим закончился возвращает true.
    var isEnd: Bool {
        return self.position == self.string.endIndex
    }

    var canMoveNext: Bool {
        guard !isEnd else { return false }
        return self.string.index(after: position) != self.string.endIndex
    }

    /// Возвращает символ, на который сейчас указывает курсор.
    /// Состояние курсора при этом не меняется.
    func current() -> Character? {
        guard !isEnd else { return nil }
        return string[position]
    }

    /// Возвращает символ на который указывает курсор.
    /// Затем сдвигает курсор на следующую позицию.
    /// В случае, если курсор сдвинуть нельзя (он указыает на последний символ)
    /// состояние курсора не изменится.
    @discardableResult
    func pop() -> Character? {
        guard !isEnd else { return nil }

        let symbol = string[position]
        self.position = string.index(after: position)
        return symbol
    }

    /// Возвращает следюущий символ (после того, на который указыает курсорс)
    /// Состояние курсора при этом не меняется.
    func next() -> Character? {
        guard self.canMoveNext else { return nil }
        return self.string[self.string.index(after: position)]
    }
}
