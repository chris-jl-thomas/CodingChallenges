//
//  GameBoard.swift
//  BattleshipGame
//
//  Created by Chris Thomas on 14/05/2020.
//  Copyright © 2020 John Lewis PLC. All rights reserved.
//

import Foundation

struct GameBoard {
    let squares: [Square]
    var numberOfHits: Int
}

struct Square: Hashable {
    let column: Column
    let row: Row
    let content: SquareContent
}


enum SquareContent {
    case unknown
    case hit
    case sunk
    case miss
}

enum Column: Hashable, Equatable {
    
    static var allCases: [Column] = [.A(), .B(), .C(), .D(), .E(), .F(), .G(), .H(), .I(), .J()]
    
    case A(value: String = "A", location: Int = 0)
    case B(value: String = "B", location: Int = 1)
    case C(value: String = "C", location: Int = 2)
    case D(value: String = "D", location: Int = 3)
    case E(value: String = "E", location: Int = 4)
    case F(value: String = "F", location: Int = 5)
    case G(value: String = "G", location: Int = 6)
    case H(value: String = "H", location: Int = 7)
    case I(value: String = "I", location: Int = 8)
    case J(value: String = "J", location: Int = 9)
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
