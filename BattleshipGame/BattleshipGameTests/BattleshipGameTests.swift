//
//  BattleshipGameTests.swift
//  BattleshipGameTests
//
//  Created by Chris Thomas on 14/05/2020.
//  Copyright © 2020 John Lewis PLC. All rights reserved.
//

import XCTest
@testable import BattleshipGame

class BattleshipGameTests: XCTestCase {

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let resource = Resource()
        
        let expectation = XCTestExpectation()
                
        resource.makeAPIRequest(with: ["A0"], player: "TestRandC", game: .test) { result in
            XCTAssertEqual(result.results, ["M"])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_fire() {
        let game = GameFunctions()
        
        game.startGame()
        _ = game.findingShot()
        XCTAssertEqual(game.board?.totalHits, 1)
    }
    
    func test_fire_hit() {
          let game = GameFunctions()
          
          game.startGame()
          _ = game.findNextHit()
        XCTAssertEqual(game.board?.numberOfHits, 1)
      }
    
    func test_find_All() {
        let game = GameFunctions()
        
        game.startGame()
        game.findAll()
        
        print(game.board?.totalHits)
        XCTAssertEqual(game.board?.numberOfHits, 16)
    }
}
