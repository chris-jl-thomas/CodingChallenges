//
//  GameBoard.swift
//  BattleshipGame
//
//  Created by Chris Thomas on 14/05/2020.
//  Copyright © 2020 John Lewis PLC. All rights reserved.
//

import Foundation

class GameBoard {
    var squares: [Square]
    var numberOfHits: Int {
        let hits = squares.filter { (square) -> Bool in
            square.content == .hit
        }
        return hits.count
    }
    var numberOfSunks: Int {
        let hits = squares.filter { (square) -> Bool in
            square.content == .sunk
        }
        return hits.count
    }
    
    var totalHits: Int = 0
    
    init(squares: [Square]) {
        self.squares = squares
    }
}

struct Square: Hashable {
    let column: Column
    let row: Row
    let content: SquareContent
}


enum SquareContent: String {
    case unknown = ""
    case hit = "H"
    case sunk = "S"
    case miss = "M"
}

enum Column: Int, Equatable, CaseIterable {
    
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
    case G = 6
    case H = 7
    case I = 8
    case J = 9
    
    var description: String {
        switch self {
        case .A:
            return "A"
        case .B:
            return "B"
        case .C:
            return "C"
        case .D:
            return "D"
        case .E:
            return "E"
        case .F:
            return "F"
        case .G:
            return "G"
        case .H:
            return "H"
        case .I:
            return "I"
        case .J:
            return "J"
        }
    }
}

enum Row: Int, CaseIterable {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
}
