import Foundation
import XCTest

enum Move: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"

}

typealias Board = [String]

func processSokobanMove(_ board: Board, _ move: String) -> Board {
    guard let move = Move(rawValue: move) else { return board }
    
    return board
}

class CodeChallenge3Tests: XCTestCase {
    func test_returnsTheBoardIfDirectionalInputIsInvalid() {
        let result = processSokobanMove(["hello"], "z")
        XCTAssertEqual(result, ["hello"])
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
CodeChallenge3Tests.defaultTestSuite.run()

