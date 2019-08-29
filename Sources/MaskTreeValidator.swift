import Foundation

/// Этот класс отвечает за валидацию полученного синтаксического дерева.
/// Сейчас он проверяет что:
/// - Регэкспы содержат только один блок репитером
public final class MaskTreeValidator {
    public func validate(maskNode: MaskExpressionTokenNode) -> Bool {

        let regexps = maskNode.next.compactMap { $0 as? RegExpExpressionTreeNode }

        for item in regexps {
            let repeaters = item.next.compactMap { $0 as? RepeatTokenTreeNode }

            if repeaters.count > 1 {
                return false
            }
        }
        return true
    }
}
