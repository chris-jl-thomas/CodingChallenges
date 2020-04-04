//
//  File.swift
//  
//
//  Created by Chris Thomas on 04/04/2020.
//

import XCTest
@testable import PokerChallenge

final class BestHandsTests: XCTestCase {
    
    func test_getBestPlayerHand_straightFlush() {
        let player = Player(name: "Alan",
                            bet: 11.00,
                            card1: Card(suit: .Diamonds, value: .King),
                            card2: Card(suit: .Diamonds, value: .Eight))
        
        let array = [
            Card(suit: .Diamonds, value: .Ten),
            Card(suit: .Diamonds, value: .Six),
            Card(suit: .Diamonds, value: .Seven),
            Card(suit: .Diamonds, value: .Nine),
            Card(suit: .Diamonds, value: .Four)]
        
        let expected: [Card] = [
            Card(suit: .Diamonds, value: .Ten),
            Card(suit: .Diamonds, value: .Nine),
            Card(suit: .Diamonds, value: .Eight),
            Card(suit: .Diamonds, value: .Seven),
            Card(suit: .Diamonds, value: .Six)]
        
        XCTAssertEqual(player.getBestHand(river: array).cards, expected)
        XCTAssertEqual(player.getBestHand(river: array).type, .straightFlush)
    }
    
    func test_getBestPlayerHand_flushGotStraightAvailable() {
        let player = Player(name: "Alan",
                            bet: 11.00,
                            card1: Card(suit: .Diamonds, value: .King),
                            card2: Card(suit: .Diamonds, value: .Eight))
        
        let array = [
            Card(suit: .Hearts, value: .Five),
            Card(suit: .Diamonds, value: .Six),
            Card(suit: .Diamonds, value: .Seven),
            Card(suit: .Diamonds, value: .Nine),
            Card(suit: .Diamonds, value: .Four)]
        
        let expected: [Card] = [
            Card(suit: .Diamonds, value: .King),
            Card(suit: .Diamonds, value: .Nine),
            Card(suit: .Diamonds, value: .Eight),
            Card(suit: .Diamonds, value: .Seven),
            Card(suit: .Diamonds, value: .Six)]
        
        XCTAssertEqual(player.getBestHand(river: array).cards, expected)
        XCTAssertEqual(player.getBestHand(river: array).type, .flush)
    }
    
    func test_bestHand_fourOfAKind() {
        let player = Player(name: "Alan",
                            bet: 11.00,
                            card1: Card(suit: .Diamonds, value: .King),
                            card2: Card(suit: .Diamonds, value: .Eight))
        
        let array = [
            Card(suit: .Hearts, value: .Eight),
            Card(suit: .Spades, value: .Eight),
            Card(suit: .Clubs, value: .Eight),
            Card(suit: .Diamonds, value: .Nine),
            Card(suit: .Diamonds, value: .Four)]
        
        let expected: [Card] = [
            Card(suit: .Clubs, value: .Eight),
            Card(suit: .Diamonds, value: .Eight),
            Card(suit: .Hearts, value: .Eight),
            Card(suit: .Spades, value: .Eight),
            Card(suit: .Diamonds, value: .King)]
        
        let bestHand = player.getBestHand(river: array)
        XCTAssertEqual(bestHand.cards, expected)
        XCTAssertEqual(bestHand.type, .fourOfAKind)
    }
    
    func test_bestHand_bestFullHouse() {
        let player = Player(name: "Alan",
                            bet: 11.00,
                            card1: Card(suit: .Diamonds, value: .Seven),
                            card2: Card(suit: .Diamonds, value: .Eight))
        
        let array = [
            Card(suit: .Hearts, value: .Eight),
            Card(suit: .Spades, value: .Eight),
            Card(suit: .Clubs, value: .Nine),
            Card(suit: .Diamonds, value: .Nine),
            Card(suit: .Hearts, value: .Seven)]
        
        let expected: [Card] = [
            Card(suit: .Diamonds, value: .Eight),
            Card(suit: .Hearts, value: .Eight),
            Card(suit: .Spades, value: .Eight),
            Card(suit: .Clubs, value: .Nine),
            Card(suit: .Diamonds, value: .Nine)]
        
        let bestHand = player.getBestHand(river: array)
        XCTAssertEqual(bestHand.cards, expected)
        XCTAssertEqual(bestHand.type, .fullHouse)
    }
}
