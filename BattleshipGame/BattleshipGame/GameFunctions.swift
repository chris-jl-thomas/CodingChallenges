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
    let group = DispatchGroup()
    
    func startGame() {
        
        let squares = Column.allCases.flatMap { column in
            return Row.allCases.map { row in
                Square(column: column, row: row, content: .unknown)
            }
        }
        
        board = GameBoard(squares: squares)
    }
    
    func runGame() {
        guard let board = board else {return}
        while (board.numberOfSunks + board.numberOfHits) != 18 && board.totalHits < 100 {
            guard let firstHit = findNextHit() else {
                return
            }
           kill(startingSquare: firstHit)
        }
        print(board.totalHits)
    }
    
    func kill(startingSquare: Square) {
       rowShot(startingSquare: startingSquare)
    }

    func rowShot(startingSquare: Square) {
        var squares: [Square] = []

        let numberOfShots = min( 4, 9 - startingSquare.row.rawValue)

        for i in 1...numberOfShots {
            guard let row = Row(rawValue: startingSquare.row.rawValue + i)
                else {
                    return
            }
            squares.append(Square(column: startingSquare.column, row: row, content: .unknown))
        }

        makeGuess(shots: squares, player: player, game: game)
    }
    
    func columnShot(startingSquare: Square) {
        var squares: [Square] = []

        let numberOfShots = min( 4, 9 - startingSquare.column.rawValue)

        for i in 1...numberOfShots {
            guard let column = Column(rawValue: startingSquare.column.rawValue + i)
                else {
                    return
            }
            squares.append(Square(column: column, row: startingSquare.row, content: .unknown))
        }

        makeGuess(shots: squares, player: player, game: game)
    }
    
    func findNextHit() -> Square? {
        var lastSquareShot: Square? = nil
        
        while lastSquareShot?.content != .hit {
            guard let square = findingShot() else { return nil }
            lastSquareShot = square
        }
        return lastSquareShot
    }
    
    func findAll() {
        
        while (board!.numberOfHits + board!.numberOfSunks) != 18 {
            findNextHit()
        }
    }
    
    func findingShot() -> Square? {
        let index = board?.squares.firstIndex(where: { (square) -> Bool in
            square.content == .unknown
        })
        
        guard
            let unwrapped = index,
            let square = board?.squares[unwrapped]
        else {
            return nil
        }
        
        makeGuess(shots: [square], player: player, game: game)
        
        return board?.squares[unwrapped]
    }
    
    
    func makeGuess(shots: [Square], player: String, game: Game) {
        
        let shotsString: [String] = shots.map { square in
            return square.column.description + "\(square.row.rawValue)"
        }
        group .enter()
        resource.makeAPIRequest(with: shotsString, player: player, game: game) { result in
            self.createBoardFromResult(shots: shots, result: result)
            self.group.leave()
        }
        _ = group.wait(timeout: .distantFuture)
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
