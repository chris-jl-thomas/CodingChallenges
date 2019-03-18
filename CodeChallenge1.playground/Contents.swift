import Foundation
import XCTest

struct ValueAndRemainder: Equatable {
    let value: Int
    let remainder: Int
}

struct Time {
    static let second = (name: "second", numberOfSeconds: 1)
    static let minute = (name: "minute", numberOfSeconds: 60)
    static let hour = (name: "hour", numberOfSeconds: 3600)
    static let day = (name: "day", numberOfSeconds: 86400)
    static let year = (name: "year", numberOfSeconds: 31536000)
    
    static let all = [year, day, hour, minute, second]
}

/// Converts a number of seconds into a number of the chosen units and the remainder of the seconds left
/// - returns: A struct of number of whole units the number of seconds can be converted to, and the remaining number of seconds left
/// - parameters:
///     - seconds: The number of seconds you wish to convert (Int)
///     - unitInSeconds: The equivalent number of seconds equal to the unit you want to convert to  (e.g: 1 minute = 60 seconds

func secondsToUnitAndRemainder(_ seconds: Int, unitInSeconds: Int) -> ValueAndRemainder {
    if seconds < 0 || unitInSeconds <= 0 {
        return ValueAndRemainder(value: 0, remainder: 0)
    }
    return ValueAndRemainder(value: seconds / unitInSeconds, remainder: seconds % unitInSeconds)
}

XCTAssertEqual(secondsToUnitAndRemainder(-1, unitInSeconds: -1), ValueAndRemainder(value: 0, remainder: 0))
XCTAssertEqual(secondsToUnitAndRemainder(1, unitInSeconds: 0), ValueAndRemainder(value: 0, remainder: 0))
XCTAssertEqual(secondsToUnitAndRemainder(-1, unitInSeconds: 60), ValueAndRemainder(value: 0, remainder: 0))
XCTAssertEqual(secondsToUnitAndRemainder(2, unitInSeconds: -60), ValueAndRemainder(value: 0, remainder: 0))
XCTAssertEqual(secondsToUnitAndRemainder(0, unitInSeconds: 60), ValueAndRemainder(value: 0, remainder: 0))
XCTAssertEqual(secondsToUnitAndRemainder(1, unitInSeconds: 60), ValueAndRemainder(value: 0, remainder: 1))
XCTAssertEqual(secondsToUnitAndRemainder(60, unitInSeconds: 60), ValueAndRemainder(value: 1, remainder: 0))
XCTAssertEqual(secondsToUnitAndRemainder(61, unitInSeconds: 60), ValueAndRemainder(value: 1, remainder: 1))
XCTAssertEqual(secondsToUnitAndRemainder(121, unitInSeconds: 60), ValueAndRemainder(value: 2, remainder: 1))

/// Creates a string for the number of units and  unit (measure of time). If the unit passed in is less than 1 the function will return nil.
/// - returns: An optional string that will be nil if the value inputted is 0 or less, will return a singular string if the value is 1, and a plural string if the value is 2 or greater. E.g nil, 1 year or 2 years
/// - parameters:
///     - value: an integer representing the number of units to create a string for
///     - unit: the string value of the unit to create a string for
func createTimePrefix(for valueAndRemainder: ValueAndRemainder, with unit: String) -> String? {
    if valueAndRemainder.value <= 0 {
        return nil
    }
    if valueAndRemainder.value == 1 {
        return "\(valueAndRemainder.value) " + unit
    }
    return "\(valueAndRemainder.value) " + unit + "s"
}

XCTAssertEqual(createTimePrefix(for: ValueAndRemainder(value: 0, remainder: 0), with: Time.year.name), nil)
XCTAssertEqual(createTimePrefix(for: ValueAndRemainder(value: 60, remainder: 0), with: Time.year.name), "60 years")
XCTAssertEqual(createTimePrefix(for: ValueAndRemainder(value: 5, remainder: 3), with: Time.hour.name), "5 hours")
XCTAssertEqual(createTimePrefix(for: ValueAndRemainder(value: 0, remainder: 3), with: Time.hour.name), nil)
XCTAssertEqual(createTimePrefix(for: ValueAndRemainder(value: -1, remainder: 3), with: Time.hour.name), nil)
XCTAssertEqual(createTimePrefix(for: ValueAndRemainder(value: 1, remainder: 3), with: Time.minute.name), "1 minute")

/// Creates a string from an array of strings, deciding whether to add a comma or an and as a separator
///
/// Uses the .dropLast, .count, .last and .joined functions on a Swift array.
/// - returns: An optional string of the format x, y and z
/// - parameters:
///     - array: An array of strings
///
func createFormattedString(from array: [String]) -> String? {
    
    guard array.count > 1, let last = array.last else { return array.last }
    
    return array.dropLast().joined(separator: ", ") + " and " + last
}

XCTAssertEqual(createFormattedString(from: ["60 years", "3 days", "5 hours"]), "60 years, 3 days and 5 hours")
XCTAssertEqual(createFormattedString(from: ["60 years", "3 days", "5 hours", "4 minutes", "1 second"]), "60 years, 3 days, 5 hours, 4 minutes and 1 second")
XCTAssertEqual(createFormattedString(from: ["60 years", "3 days"]), "60 years and 3 days")
XCTAssertEqual(createFormattedString(from: ["3 days"]), "3 days")
XCTAssertEqual(createFormattedString(from: []), nil)


func formatTime(seconds: Int) -> String {
    
    var secondsToCalculateWith = seconds
    let array = Time.all.compactMap { time -> String? in
        let valueAndRemainder = secondsToUnitAndRemainder(secondsToCalculateWith, unitInSeconds: time.numberOfSeconds)
        secondsToCalculateWith = valueAndRemainder.remainder
        return createTimePrefix(for: valueAndRemainder, with: time.name)
    }
    
    guard let formattedString = createFormattedString(from: array) else { return "none" }
    return formattedString
}

XCTAssertEqual(formatTime(seconds: 1), "1 second")
XCTAssertEqual(formatTime(seconds: 2), "2 seconds")
XCTAssertEqual(formatTime(seconds: 62), "1 minute and 2 seconds")
XCTAssertEqual(formatTime(seconds: 3662), "1 hour, 1 minute and 2 seconds")
XCTAssertEqual(formatTime(seconds: 3660), "1 hour and 1 minute")
XCTAssertEqual(formatTime(seconds: 0), "none")
XCTAssertEqual(formatTime(seconds: -1), "none")

formatTime(seconds: (3600 * 24 * 365 * 3 + 1))

formatTime(seconds: 4567890678)
