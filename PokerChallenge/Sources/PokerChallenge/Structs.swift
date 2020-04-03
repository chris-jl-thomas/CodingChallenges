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
