//
//  GameFunctions.swift
//  BattleshipGame
//
//  Created by Chris Thomas on 14/05/2020.
//  Copyright © 2020 John Lewis PLC. All rights reserved.
//

import Foundation

class GameFunctions {
    
    let resource = Resource()
    var lastResult: APIResponse?
    var board: GameBoard?
    
    func startGame() {
        
        let squares = Column.allCases.flatMap { column in
            return Row.allCases.map { row in
                Square(column: column, row: row, content: .unknown)
            }
        }
        
        board = GameBoard(squares: squares, numberOfHits: 0)
    }
    
    
    
    func makeGuess(shots: [String], player: String, game: Game) {
        resource.makeAPIRequest(with: shots, player: player, game: game) { result in
            self.lastResult = result
            print(result)
        }
    }
}
