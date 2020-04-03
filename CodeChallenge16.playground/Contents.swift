import Foundation

extension String {
    enum RomanParsingError: Error {
        case invalidNumber
    }
    func romanNumeralValue() throws -> Int  {
        guard range(of: "^(?=[MDCLXVI])M*(C[MD]|D?C{0,3})(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$", options: .regularExpression) != nil else {
            throw RomanParsingError.invalidNumber
        }
        var result = 0
        var maxValue = 0
        uppercased().reversed().forEach {
            let value: Int
            switch $0 {
            case "M":
                value = 1000
            case "D":
                value = 500
            case "C":
                value = 100
            case "L":
                value = 50
            case "X":
                value = 10
            case "V":
                value = 5
            case "I":
                value = 1
            default:
                value = 0
            }
            maxValue = max(value, maxValue)
            result += value == maxValue ? value : -value
        }
        return result
    }
}

func addRomanNumerals(_ x: String, and y: String) throws -> Int {
    return try x.romanNumeralValue() + y.romanNumeralValue()
}

try addRomanNumerals("I", and: "IV")
