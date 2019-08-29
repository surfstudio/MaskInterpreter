import Foundation

public enum SliceGeneratorError: Error {
    /// Возникает в случае, если символ содержит больше одного кванта юникода.
    /// Вероятно в случае сложных символов в разных языках.
    case sliceChildContainMoreThatOneUniceScalar(Character)

    /// Вот это вообще на самом деле неверотяная проблема,
    /// но раз свифт опциональный, то пришлось предусмотреть.
    case characterHasNoOneScalar(Character)
}

/// Используется для получения допустимого `CharacterSet` из `SliceTreeNode`
///
/// SeeAlso:
/// - `SliceTreeNode`
/// - `SliceGenerator`
/// - `SliceGeneratorError`
public final class SliceGenerator {

    /// Возвращает множество допустимых символов.
    /// - Parameter node: Узел для генерации
    /// - Throws:
    ///     - `SliceGeneratorError.sliceChildContainMoreThatOneUniceScalar`
    ///     - `SliceGeneratorError.characterHasNoOneScalar`
    public func generate(from node: SliceTreeNode) throws -> CharacterSet {

        let left = node.left.symbol
        let right = node.right.symbol

        guard left.unicodeScalars.count == 1 else {
            throw SliceGeneratorError.sliceChildContainMoreThatOneUniceScalar(left)
        }

        guard right.unicodeScalars.count == 1 else {
            throw SliceGeneratorError.sliceChildContainMoreThatOneUniceScalar(right)
        }

        guard let leftScalar = left.unicodeScalars.first else {
            throw SliceGeneratorError.characterHasNoOneScalar(left)
        }

        guard let rightScalar = right.unicodeScalars.first else {
            throw SliceGeneratorError.characterHasNoOneScalar(right)
        }

        let set = CharacterSet(charactersIn: leftScalar...rightScalar)

        return set
    }
}
