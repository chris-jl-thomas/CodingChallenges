import Foundation
import XCTest

enum Move: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"

}

enum Object: String {
    case wall = "#"
    case player = "p"
    case playerOnStorage = "P"
    case storage = "*"
    case box = "b"
    case boxOnStorage = "B"
    case space = " "
}

typealias Board = [String]
typealias CartesianBoard = [Int: [Int: Character]]
typealias Coordinates = (x: Int, y: Int)

func createCartesianBoard(_ board: Board) -> CartesianBoard {
    let indexedCharacterArray = board.enumerated().map { (index, line) -> [Int: Character] in
        let tuple = line.enumerated().map { (arg) -> (index: Int, character: Character) in
            
            let (index, character) = arg
            return (index, character)
        }
        
        return tuple.reduce(into: [Int: Character]()) {
            return $0[$1.index] = $1.character
        }
    }
    
    return indexedCharacterArray.enumerated().reduce(into: CartesianBoard()) {
        return $0[$1.0] = $1.1
    }
    
    
}

func getXForPlayer(_ plane: [Int: Character]) -> [Int: Character] {
    return plane.filter{ (key: Int, value: Character) -> Bool in
        guard let object = Object(rawValue: String(value)) else { return false }
        switch object {
        case .player, .playerOnStorage:
                return true
        default:
            return false
        }
    }
}

func getXForStorage(_ plane: [Int: Character]) -> [Int: Character] {
    return plane.filter{ (key: Int, value: Character) -> Bool in
        guard let object = Object(rawValue: String(value)) else { return false }
        switch object {
        case .storage:
            return true
        default:
            return false
        }
    }
}


func getPlayerCoordinates(_ cartesianBoard: CartesianBoard) -> Coordinates? {
    let yPlane = cartesianBoard.filter { (key: Int, value: [Int : Character]) -> Bool in
        
        let x = getXForPlayer(value)
        
        if x.count == 1 {
            return true
        }
        
        return false
    }
    
    // This is a one player game, so the board is invalid if you return more than one player here
    
    guard yPlane.count == 1, let y = yPlane.keys.first, let xPlane = yPlane[y]else { return nil }
    
    let xPosition = getXForPlayer(xPlane)
    
    guard xPosition.count == 1, let x = xPosition.keys.first else { return nil }
    
    return (x, y)
}

func getStorageCoordinates(_ cartesianBoard: CartesianBoard) -> [Coordinates] {
    let yPlane = cartesianBoard.filter { (key: Int, value: [Int : Character]) -> Bool in
        
        let x = getXForStorage(value)
        
        if x.count >= 1 {
            return true
        }
        return false
    }
    
    var coordinates: [Coordinates] = []
    yPlane.forEach { (yKey: Int, value: [Int : Character]) in
        let xs = getXForStorage(value)
        xs.keys.forEach{
            coordinates.append(($0, yKey))
        }
    }
    
    return coordinates
}

func getDesiredCoordiantes(for move: Move, from coordinates: Coordinates) -> Coordinates {
    switch move {
    case .up:
        return (coordinates.x, coordinates.y - 1)
    case .down:
        return (coordinates.x, coordinates.y + 1)
    case .left:
        return (coordinates.x - 1, coordinates.y)
    case .right:
        return (coordinates.x + 1, coordinates.y)
    }
}

func canMove(for move: Move, _ playerCoordinates: Coordinates, _ board: CartesianBoard, _ previousObject: Object? = nil) -> Bool {
    let desiredNewCoordinates = getDesiredCoordiantes(for: move, from: playerCoordinates)
    guard let yPlane = board[desiredNewCoordinates.y],
        let characterAtNewCoordinate = yPlane[desiredNewCoordinates.x],
        let object = Object(rawValue: String(characterAtNewCoordinate)) else { return true }
    
    switch object {
        case .box, .boxOnStorage:
            break
        case .storage:
            return true
        case .space:
            return true
        case .player, .playerOnStorage, .wall:
            return false
    }
    
    // cant move 2 boxes
    if previousObject == .box {
        return false
    }
    
    return canMove(for: move, desiredNewCoordinates, board, .box)
}


func processSokobanMove(_ board: Board, _ move: String) -> Board {
    guard let move = Move(rawValue: move) else { return board }
    let cartesianBoard = createCartesianBoard(board)
    
    let storageCoordinates = getStorageCoordinates(cartesianBoard)
    // find the y position of player
    guard let playerCoordinates = getPlayerCoordinates(cartesianBoard) else { return board }
    
    let can = canMove(for: move, playerCoordinates, cartesianBoard)
    
    print(can)
    print(storageCoordinates)
    print(playerCoordinates)
    
    // try and move the player in that direction
    
    // need to know if the box moved too
    
    // need to check if the box or player moved off storage :(
    
    return []
}

processSokobanMove(["####",
                    "#P #",
                    "#**#",
                    "####"], "R")

class CodeChallenge3Tests: XCTestCase {
    func test_returnsTheBoardIfDirectionalInputIsInvalid() {
        let result = processSokobanMove(["hello"], "z")
        XCTAssertEqual(result, ["hello"])
    }
    
    func test_returnsTheBoardIfThePlayerCantMoveLeft() {
        let result = processSokobanMove(["###",
                                         "#p#",
                                         "###"], "L")
        XCTAssertEqual(result, ["###",
                                "#p#",
                                "###"])
    }
    
    func test_returnsTheBoardIfThePlayerCantMoveRight() {
        let result = processSokobanMove(["###",
                                         "#p#",
                                         "###"], "R")
        XCTAssertEqual(result, ["###",
                                "#p#",
                                "###"])
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

