[![codecov](https://codecov.io/gh/LastSprint/MaskInterpreter/branch/master/graph/badge.svg)](https://codecov.io/gh/LastSprint/MaskInterpreter)
[![Actions Status](https://github.com/LastSprint/MaskInterpreter/workflows/CI/badge.svg)](https://github.com/LastSprint/MaskInterpreter/actions)
# MaskInterpreter

Интерпритататор масок ввода из кастомного формата в формат [InputMask](https://github.com/RedMadRobot/input-mask-ios)
Эта библиотека позволяет сделать две вещи:
1. Транслировать одну грамматику в другую
2. Проводить простой анализ грамматики и понимать:
  - Минимальное и максимальное кол-во символов для ввода
  - Тип клавиатуры для ввода (телефон, e-mail, просто цифры и т.д.)
  
## Грамматика

Интерпритатор позволяет сконвертировать одну грамматику в другую. 

Рассмотрим грамматику, которую интерпритатор ожидает на вход:

### Легенда

Все что внутри `""` - константный символ. 
Зарезервированные символы:
- `.` - Любой символ
- `|` - Логическое ИЛИ
- `(...)` - группа выражений
- `+` - повторить предыдущее выражение 1 или более раз
- `.` - любой символ

### Токены

```
CONSTANT_SYMBOL = . 
SPECIAL_SYMBOL = "\\d" | "\\w" | "\\s" | "\\D" | "\\W" | "\\S"
ANY_SYMBOL = "."
REPEATER_SYMBOL = "+" | "*"
REGEXP_START_SYMBOL = "<!^"
REGEXP_END_SYMBOL = ">"
SLICE_SYMBOL = "-"
ONE_OF_START_SYMBOL = "["
ONE_OF_END_SYMBOL = "]"
RANGE_START_SYMBOL = "{"
RANGE_END_SYMBOL = "}"
RANGE_DELIMETER_SYMBOL = ","
REGEXP_META_START_SYMBOL = "$"
```
### Правила

```
regexpSymbolRule = SPECIAL_SYMBOL  | CONSTANT_SYMBOL

regexpSliceRule = CONSTANT_SYMBOL SLICE_SYMBOL CONSTANT_SYMBOL

regexpOneOfRule = ONE_OF_START_SYMBOL regexpSliceRule | regexpSymbolRule ONE_OF_END_SYMBOL

regexpRepeatSymbolRule = (ANY_SYMBOL | regexpSymbolRule | regexpOneOfRule) REPEATER_SYMBOL

regexpBodyRule = regexpRepeatSymbolRule | regexpOneOfRule | regexpSymbolRule

regexpRangeRule = RANGE_START_SYMBOL CONSTANT_SYMBOL (RANGE_DELIMETER_SYMBOL CONSTANT_SYMBOL)? RANGE_END_SYMBOL where CONSTANT_SYMBOL is NUMBER

regexpMetaRule = REGEXP_META_START_SYMBOL regexpRangeRule

regexpExpression = REGEXP_START_SYMBOL regexpBodyRule+ regexpMetaRule REGEXP_END_SYMBOL

maskExpression = (ConstantSymbol | regexpExpression)+
```

### Примеры 

`+7 (<!^\\d+${3}>)<!^\\d+${3}>-<!^\\d+${2}>-<!^\\d+${2}>` - маска для номера телефона. 

Все что находится снаружи `<!^...>` это константы (автоматически подставляются), остальное - динамическая часть, которую должен вводить пользователь. 

`${x,y}` описывает кол-во символов для повтора (`\\d+${3}` означает повторить `\\d` ровно 3 раза)

`<!^[0-9А-Яа-яЁё\\s\-]+${1,70}>` - маска для обычного пользовательского ввода. 

**ВАЖНО**

Одно динамическое выражение может содержать только 1 токен повторения.

## Как использовать

```Swift

let rawMask = "<!^\\d+${1,9}>/<!^\\d+${4}>"

guard let mask = MaskInterpreter().interprete(rawMask: rawMask) else { return }

let maskNotations = mask.generated.notations.map { generated in
  return Notation(character: generated.nameSymbol, characterSet: generated.set, isOptional: generated.isOptional)
}

self.maskInputLisnter.customNotations = maskNotations
self.maskInputLisnter.primaryMaskFormat = mask.generated.mask
```
