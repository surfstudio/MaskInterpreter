import Foundation

public final class MaskGenerator {

    private lazy var regexpGenerator = RegexpGenerator()

    // swiftlint:disable cyclomatic_complexity
    public func generate(from node: MaskExpressionTokenNode) throws -> GeneratedMask {

        var mask = ""
        var notations = [MaskNotation]()

        var minAllSymbols = 0
        var maxAllSymbols = 0

        let mandatory = GeneratorConstants.availableMandatoryCharacters
        let optional = GeneratorConstants.availableOptionalCharacters

        let maxSymbols = mandatory.count

        var index = 0

        for item in node.next {
            switch item.nodeToken {
            case .specialSymbol, .slice, .repeater, .oneOf, .mask:
                throw GeneratorError.cantMatchThisNode(item)
            case .constantSymbol:
                guard let constNode = item as? ConstantSymbolNode else {
                    throw GeneratorError.inconsistensyState("\(node) has `.constantSymbol`")
                }
                minAllSymbols += 1
                maxAllSymbols += 1
                mask.append(constNode.symbol)
            case .regexp:
                // Написано так, для того, чтобы соблюсти thread safety
                // и не придумывать велосипедов с пробросом двух массивов символов.

                // Получаем нужный узел
                guard let regexpNode = item as? RegExpExpressionTreeNode else {
                    throw GeneratorError.inconsistensyState("\(node) has `.constantSymbol`")
                }

                // Генерируем нотацию
                let specNotation = try self.regexpGenerator.generate(from: regexpNode)

                let repeatedCount = specNotation.sets.filter { $0.repeated }.count

                // Невозможно сгенерировать маску если в регэкспе больше двух репитеров,
                // потому что ограничение на размер есть не у репитеров, а у регэкспа
                guard repeatedCount <= 1 else {
                    throw MaskGeneratorError.regexpCantContainsMoreThenOneRepeatedSet
                }

                var internalMask = "["
                var internalNotations = [MaskNotation]()

                try specNotation.sets.forEach { note in

                    // Не хочу даже знать что это за регэксп такой,
                    // в котором будет сетов больеш чем символов в двух алфавитах
                    guard index < maxSymbols else {
                        throw MaskGeneratorError.tooManyRegexps
                    }

                    let symbolM = mandatory[index]
                    let symbolO = optional[index]

                    index += 1

                    // Если узел не повторяемый, то просто запихиваем символ и идем дальше
                    guard note.repeated else {
                        minAllSymbols += 1
                        maxAllSymbols += 1
                        internalMask.append(symbolM)
                        internalNotations.append(.init(nameSymbol: symbolM, set: note.set, isOptional: false))
                        return
                    }

                    minAllSymbols += specNotation.min
                    maxAllSymbols += specNotation.min

                    internalMask += String(repeating: symbolM, count: specNotation.min)
                    internalNotations.append(.init(nameSymbol: symbolM, set: note.set, isOptional: false))

                    guard let max = specNotation.max else {
                        return
                    }

                    maxAllSymbols += max

                    internalMask += String(repeating: symbolO, count: max - specNotation.min)
                    internalNotations.append(.init(nameSymbol: symbolO, set: note.set, isOptional: true))
                }

                guard !internalNotations.isEmpty else {
                    throw MaskGeneratorError.regexpCanNotBeEmpty
                }

                internalMask += "]"
                mask += internalMask
                notations += internalNotations
            }
        }
        return .init(mask: mask, notations: notations, min: minAllSymbols, max: maxAllSymbols)
    }
    // swiftlint:enable cyclomatic_complexity
}
