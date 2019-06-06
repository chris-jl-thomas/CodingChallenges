import UIKit

typealias Board = [String]
typealias CartesianBoard = [Int: [Int: BoardSpace]]
typealias Coordinates = (x: Int, y: Int)

enum GridStatus: String {
    case redNext = "Red plays next"
    case yellowNext = "Yellow plays next"
    case redWins = "Red wins"
    case yellowWins = "Yellow wins"
    case draw = "Draw" // this means there are no empty spaces left on the grid.
}

enum BoardSpace: String {
    case latestRed = "R"
    case latestYellow = "Y"
    case red = "r"
    case yellow = "y"
    case empty = "."
}

func getXForLatestToken(_ plane: [Int: BoardSpace]) -> [Int: BoardSpace] {
    return plane.filter{ (key: Int, value: BoardSpace) -> Bool in
        switch value {
        case .latestRed, .latestYellow:
            return true
        default:
            return false
        }
    }
}

func getPlayerCoordinates(_ cartesianBoard: CartesianBoard) -> Coordinates?{
    let yPlane = cartesianBoard.filter { (key: Int, value: [Int : BoardSpace]) -> Bool in
        
        let x = getXForLatestToken(value)
        
        if x.count == 1 {
            return true
        }
        
        return false
    }
    
    // This is a one player game, so the board is invalid if you return more than one player here
    
    guard yPlane.count == 1, let y = yPlane.keys.first, let xPlane = yPlane[y]else { return nil }
    
    let xPosition = getXForLatestToken(xPlane)
    
    guard xPosition.count == 1, let x = xPosition.keys.first else { return nil }
    
    return (x, y)
}

func createCartesianBoard(_ board: Board) -> CartesianBoard {
    let indexedCharacterArray = board.enumerated().map { (index, line) -> [Int: BoardSpace] in
        let tuple = line.enumerated().map { (arg) -> (index: Int, character: BoardSpace) in
            
            let (index, character) = arg
            return (index, BoardSpace(rawValue: String(character))!)
        }
        
        return tuple.reduce(into: [Int: BoardSpace]()) {
            return $0[$1.index] = $1.character
        }
    }
    
    return indexedCharacterArray.enumerated().reduce(into: CartesianBoard()) {
        return $0[$1.0] = $1.1
    }
    
    
}

func isThereSpace(_ board: Board) -> Bool {
    let filteredBoard = board.filter { xPlane in
        let y = xPlane.filter { character in
            return String(character) == "."
        }
        return y.count > 0
    }
    return filteredBoard.count > 0
}

func getGridStatus(_ board: Board) -> String {
    let cartestianBoard = createCartesianBoard(board)
    guard let (x, y) = getPlayerCoordinates(cartestianBoard) else { return GridStatus.redNext.rawValue}
    let token = cartestianBoard[y]![x]
    return ""
}

let board = [".......",
             ".......",
             ".R.....",
             ".r.....",
             ".ry....",
             ".ryyy.."]

let cartesianBoard = createCartesianBoard(board)
let (x, y) = getPlayerCoordinates(cartesianBoard)!
cartesianBoard[y]![x]?.rawValue
