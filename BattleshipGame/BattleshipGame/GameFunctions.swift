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
    let player: String = "TestRandC"
    let game: Game = .test
    
    func startGame() {
        
        let squares = Column.allCases.flatMap { column in
            return Row.allCases.map { row in
                Square(column: column, row: row, content: .unknown)
            }
        }
        
        board = GameBoard(squares: squares)
    }
    
    func findingShot() -> Bool {
        let index = board?.squares.firstIndex(where: { (square) -> Bool in
            square.content == .unknown
        })
        
        guard
            let unwrapped = index,
            let square = board?.squares[unwrapped]
        else {
            return false
        }
        
        makeGuess(shots: [square], player: player, game: game)
        
        return board?.squares[unwrapped].content == .hit
    }
    
    
    func makeGuess(shots: [Square], player: String, game: Game) {
        
        let shotsString: [String] = shots.map { square in
            return square.column.description + "\(square.row.rawValue)"
        }
        
        resource.makeAPIRequest(with: shotsString, player: player, game: game) { result in
            self.createBoardFromResult(shots: shots, result: result)
        }
    }
    
    func createBoardFromResult(shots: [Square], result: APIResponse) {
        board?.totalHits += shots.count
        
        let newSquares = result.results.enumerated().map { (index, content) in
            Square(column: shots[index].column, row: shots[index].row, content: SquareContent(rawValue: content) ?? .unknown)
        }
        
        newSquares.forEach { square in
            board?.replace(square: square)
        }
    }
    
}

extension GameBoard {
    func replace(square: Square) {
        let index = self.squares.firstIndex { (oldSquare) -> Bool in
            oldSquare.column == square.column && oldSquare.row == square.row
        }
        
        guard let unwrapped = index else { return }
        
        self.squares[unwrapped] = square
        
    }
    
    func gameOver() -> Bool {
        let contents = squares.map { $0.content }
        let sunk = contents.filter { (content) -> Bool in
            content == .sunk
        }
        
        return sunk.count == 18
    }
}
