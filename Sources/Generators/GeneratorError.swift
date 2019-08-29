import Foundation

/// Общие ошибки для генераторов.
public enum GeneratorError: Error {
    /// Возникает в случае, если генератор получил узел,
    /// который он не умеет обрабатывать
    case cantMatchThisNode(ASTNode)

    /// Возникает в случае, если состояние синтаксического дерева неконсистентно.
    /// Например узел содержит неправильный ASTToken.
    case inconsistensyState(String)
}
