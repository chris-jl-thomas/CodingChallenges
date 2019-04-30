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
        let objectAtNewCoordinate = Object(rawValue: String(characterAtNewCoordinate)) else { return true }
    
    switch objectAtNewCoordinate {
    case .box:
        break
    case .boxOnStorage:
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

func getNewBoard(for move: Move, _ playerCoordinates: Coordinates, _ board: CartesianBoard) -> CartesianBoard {
    let desiredNewCoordinates = getDesiredCoordiantes(for: move, from: playerCoordinates)
    guard let yPlane = board[desiredNewCoordinates.y],
        let characterAtNewCoordinate = yPlane[desiredNewCoordinates.x],
        let objectAtNewCoordinate = Object(rawValue: String(characterAtNewCoordinate)) else { return board }
    
    guard let playerCharacter = board[playerCoordinates.y]?[playerCoordinates.x],
        let playerObject = Object(rawValue: String(playerCharacter)) else { return board }
    
    var mutatableDictionary = board
    switch objectAtNewCoordinate {
    case .box:
        mutatableDictionary[desiredNewCoordinates.y]?[desiredNewCoordinates.x] = "p"
        mutatableDictionary[playerCoordinates.y]?[playerCoordinates.x] = playerObject == .player ? " " : "*"
        
        let newBoxCoordinates = getDesiredCoordiantes(for: move, from: desiredNewCoordinates)
        guard let boxCharacter = board[newBoxCoordinates.y]?[newBoxCoordinates.x],
            let boxObject = Object(rawValue: String(boxCharacter)) else { return board }
        mutatableDictionary[newBoxCoordinates.y]?[newBoxCoordinates.x] = boxObject == .storage ? "B" : "b"
        return mutatableDictionary
    case .boxOnStorage:
        mutatableDictionary[desiredNewCoordinates.y]?[desiredNewCoordinates.x] = "P"
        mutatableDictionary[playerCoordinates.y]?[playerCoordinates.x] = playerObject == .player ? " " : "*"
        
        let newBoxCoordinates = getDesiredCoordiantes(for: move, from: desiredNewCoordinates)
        guard let boxCharacter = board[newBoxCoordinates.y]?[newBoxCoordinates.x],
            let boxObject = Object(rawValue: String(boxCharacter)) else { return board }
        mutatableDictionary[newBoxCoordinates.y]?[newBoxCoordinates.x] = boxObject == .storage ? "B" : "b"
        return mutatableDictionary
    case .storage:
        mutatableDictionary[desiredNewCoordinates.y]?[desiredNewCoordinates.x] = "P"
        mutatableDictionary[playerCoordinates.y]?[playerCoordinates.x] = playerObject == .player ? " " : "*"
        return mutatableDictionary
    case .space:
        mutatableDictionary[desiredNewCoordinates.y]?[desiredNewCoordinates.x] = "p"
        mutatableDictionary[playerCoordinates.y]?[playerCoordinates.x] = playerObject == .player ? " " : "*"
        return mutatableDictionary
    case .player, .playerOnStorage, .wall:
        return board
    }
}

func createNewBoard(_ cartesianBoard: CartesianBoard) -> Board {
    let sortedY = CartesianBoard(uniqueKeysWithValues: cartesianBoard.sorted{ $0.key < $1.key })
    var newBoard: [String] = []
    
    for i in 0...sortedY.keys.count - 1 {
        if let xplane = sortedY[i] {
            let sortedX = [Int: Character](uniqueKeysWithValues: xplane.sorted{ $0.key < $1.key })
            var newString: String = ""
            for j in 0...sortedX.keys.count - 1 {
                newString.append(String(sortedX[j]!))
            }
            newBoard.append(newString)
        }
        
    }
    return newBoard
}

func processSokobanMove(_ board: Board, _ move: String) -> Board {
    guard let move = Move(rawValue: move) else { return board }
    let cartesianBoard = createCartesianBoard(board)
    
    guard let playerCoordinates = getPlayerCoordinates(cartesianBoard) else { return board }
    
    let can = canMove(for: move, playerCoordinates, cartesianBoard)
    
    if can {
        let newBoard = getNewBoard(for: move, playerCoordinates, cartesianBoard)
        return createNewBoard(newBoard)
    }
    
    return board
}

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
    
    func test_returnsTheBoardIfThePlayerCantMoveUp() {
        let result = processSokobanMove(["###",
                                         "#p#",
                                         "###"], "U")
        XCTAssertEqual(result, ["###",
                                "#p#",
                                "###"])
    }
    
    func test_returnsTheBoardIfThePlayerCantMoveDown() {
        let result = processSokobanMove(["###",
                                         "#p#",
                                         "###"], "D")
        XCTAssertEqual(result, ["###",
                                "#p#",
                                "###"])
    }
    
    func test_returnsPforPlayerMovedOntoStorageAndLeavesBlankIfPlayerWasp() {
        let result = processSokobanMove(["####",
                                         "#*p#",
                                         "####"], "L")
        XCTAssertEqual(result, ["####",
                                "#P #",
                                "####"])
    }
    
    func test_returnspforPlayerMovedOffOfStorageAndLeavesStorageIfPlayerWasP() {
        let result = processSokobanMove(["####",
                                         "# P#",
                                         "####"], "L")
        XCTAssertEqual(result, ["####",
                                "#p*#",
                                "####"])
    }
    
    func test_returnsTheBoardIfPlayerCantMoveABox() {
        let result = processSokobanMove(["#####",
                                         "#bp #",
                                         "#####"], "L")
        XCTAssertEqual(result, ["#####",
                                "#bp #",
                                "#####"])
    }
    
    func test_returnsBForBoxThatMovesToStorage() {
        let result = processSokobanMove(["#####",
                                         "#*bp#",
                                         "#####"], "L")
        XCTAssertEqual(result, ["#####",
                                "#Bp #",
                                "#####"])
    }
    
    func test_returnsTheBoardIfWallIsntDefined() {
        let result = processSokobanMove(["#####",
                                         "#*b     p#",
                                         "#####"], "U")
        XCTAssertEqual(result, ["#####",
                                "#*b     p#",
                                "#####"])
    }
    
    func test_returnsTheBoardIfTwoBoxes() {
        let result = processSokobanMove(["######",
                                         "# bbp#",
                                         "######"], "L")
        XCTAssertEqual(result, ["######",
                                "# bbp#",
                                "######"])
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

