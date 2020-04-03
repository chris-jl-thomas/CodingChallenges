import Foundation

public enum Suit: Equatable {
    case Clubs, Diamonds, Hearts, Spades
}

public enum Value: Int {
    case Two = 2
    case Three = 3
    case Four = 4
    case Five = 5
    case Six = 6
    case Seven = 7
    case Eight = 8
    case Nine = 9
    case Ten = 10
    case Jack = 11
    case Queen = 12
    case King = 13
    case Ace = 14
}

public struct Card: Equatable {
    public let suit: Suit
    public let value: Value
    
    public init (suit: Suit, value: Value) {
        self.suit = suit
        self.value = value
    }
}

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
