//
//  File.swift
//  
//
//  Created by Chris Thomas on 03/04/2020.
//

import Foundation

public struct Player {
    
    public let name: String
    public let bet: Decimal
    public let card1: Card
    public let card2: Card

    public init(name: String, bet: Decimal, card1: Card, card2: Card) {
        self.name = name
        self.bet = bet
        self.card1 = card1
        self.card2 = card2
    }
    
    
    public var hand: [Card] {
        [card1, card2]
    }
}


extension Player {
    func getBestHand(river: [Card]) -> [Card] {
        var hand = river
        hand = getStraightFlush(player: self, river: river)
        if !hand.isEmpty {
                return hand
        }
        
        hand = getBestFlushHand(player: self, river: river)
        if !hand.isEmpty {
                return hand
        }
        
        hand = getStraightHand(player: self, river: river)
        if !hand.isEmpty {
                return hand
        }
        
        return river
    }
}
