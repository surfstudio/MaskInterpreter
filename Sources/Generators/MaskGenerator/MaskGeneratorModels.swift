//
//  MaskGeneratorModels.swift
//  SBI
//
//  Created by Александр Кравченков on 22/07/2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import Foundation

/// Сгенерированная маска.
public struct GeneratedMask {

    /// Текстовое представление маски состоящее из специальных символов.
    public let mask: String

    /// Нотация в которой составлено соответствие между символом и `CharacterSet`-ом
    public let notations: [MaskNotation]

    /// Минимальное кол-во символов, которое может содержаться во всей маске (включая константы)
    public let min: Int

    /// Максимально число символов, которое может содержаться во всей маске (включая константы)
    public let max: Int
}

/// Нотация для описания одного символа маски.
public struct MaskNotation {

    /// Символ использующийся в текстовом представлении маски
    public let nameSymbol: Character

    /// Множество допустимых символов
    public let set: CharacterSet

    /// Является ли множество символов )и сам символ) опциональными для маскирования
    public let isOptional: Bool
}

public enum MaskGeneratorError: Error {
    /// Возникает в случае, если RegExp имеет больше одного репитера
    case regexpCantContainsMoreThenOneRepeatedSet

    /// Возникает в случае, если в маске больше регулярных выражений чем зарезервировано символов
    case tooManyRegexps

    /// Возникает в случае, если регэксп не содержит нотаций
    case regexpCanNotBeEmpty
}
