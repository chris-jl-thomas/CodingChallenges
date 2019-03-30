import Foundation
import XCTest

func assertMax(_ testValue: String, in array: [String]) -> Bool {
    for value in array {
        guard let doubleTestValue = Double(testValue) else { return false }
        guard let doubleValue = Double(value) else { return false }
        if doubleTestValue <= doubleValue {
            return false
        }
    }
    return true
}

func getNumbersAsStringsArray(from priceLabel: String) -> [String] {
    return priceLabel
            .lowercased()
            .components(separatedBy: ",")
            .compactMap {
                return String($0.trimmingCharacters(in: .whitespaces)
                    .components(separatedBy: " ")[1].dropFirst())
    }
}

func fixPriceLabel(_ priceLabel: String) -> String {
    let numbers = getNumbersAsStringsArray(from: priceLabel)
    
    var usedArray = Array(numbers.dropFirst())
    let halfWayThere = numbers.compactMap { value -> String? in
        if assertMax(value, in: usedArray) {
            usedArray = Array(usedArray.dropFirst())
            return value
        }
        usedArray = Array(usedArray.dropFirst())
        return nil
    }
    
    if halfWayThere.count == 1 {
        return "Now £\(halfWayThere.first!)"
    }
    
    let first = "Was £\(halfWayThere.first!)"
    let last = "now £\(halfWayThere.last!)"
    return ([first] + halfWayThere.dropLast().dropFirst().map { "then £\($0)"} + [last])
        .joined(separator: ", ")
    
}

class CodeChallenge2Tests: XCTestCase {
    
    // MARK: assertIsMaximum
    
    func test_assertIsMaximum_inputIsMaximum() {
        let input = "11.00"
        let array = ["10", "10.50", "0.3"]
        
        XCTAssertTrue(assertMax(input, in: array))
    }
    
    func test_assertIsMaximum_inputIsNotMaximum() {
        let input = "11.00"
        let array = ["11.00", "10.50", "100.3"]
        
        XCTAssertFalse(assertMax(input, in: array))
    }
    
    // MARK: getNumbers
    
    func test_getNumbers() {
        let input = "Was £10.00, then £9, then £8, now £6.50"
        let output = getNumbersAsStringsArray(from: input)
        XCTAssertEqual(output, ["10.00", "9", "8", "6.50"])
    }
    
    // MARK: fixPriceLabel
    
    func test_fixPriceLabel_inputDoesntChange_formatCorrect() {
        let input = "Was £10.00, then £9, then £8, now £6.50"
        XCTAssertEqual(fixPriceLabel(input), input)
    }
    
    func test_fixPriceLabel_nowOnly() {
        let input = "Was £10.00, then £9, then £8, now £16.50"
        XCTAssertEqual(fixPriceLabel(input), "Now £16.50")
    }
    
    func test_fixPriceLabel_wasnowOnly() {
        let input = "Was £17.00, then £9, then £8, now £16.50"
        XCTAssertEqual(fixPriceLabel(input), "Was £17.00, now £16.50")
    }
    
    func test_fixPriceLabel_wasthennowOnly() {
        let input = "Was £17.00, then £9, then £12.00, now £11.50"
        XCTAssertEqual(fixPriceLabel(input), "Was £17.00, then £12.00, now £11.50")
    }
}

class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
CodeChallenge2Tests.defaultTestSuite.run()


