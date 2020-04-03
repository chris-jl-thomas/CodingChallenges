func decideWinner(players: [Player], river: [Card]) {

}

func getCards(river: [Card], hand: [Card]?) -> [Card] {
    return river + (hand ?? [])
}

func getFlush(player: Player?, river: [Card]) -> Suit? {
    getCards(river: river, hand: player?.hand)
        .map { card in
            card.suit
        }
        .reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        .filter { (suit, count) in
            count >= 5
        }
        .keys
        .first
}

func getFlushCards(player: Player?, river: [Card]) -> [Card] {
    guard let suit = getFlush(player: player, river: river) else { return [] }
    
    return getCards(river: river, hand: player?.hand)
        .filter { card in
            card.suit == suit
        }
}

func getBestFlushHand(player: Player?, river: [Card]) -> [Card] {
    getFlushCards(player: player, river: river).getOrderedHand()
}

func getStraightHand(player: Player?, river: [Card]) -> [Card] {
    let potentialHand = getCards(river: river, hand: player?.hand).getOrdered()
    if (potentialHand.prefix(5).passesForConsecutiveValues {
        $0.value.rawValue - 1 == $1.value.rawValue
        
    }) {
        guard potentialHand.prefix(5).count == 5 else { return [] }
        return Array(potentialHand.prefix(5))
    }
    else if (potentialHand.dropFirst().prefix(5).passesForConsecutiveValues {
        $0.value.rawValue - 1 == $1.value.rawValue
    }) {
        guard potentialHand.dropFirst().prefix(5).count == 5 else { return [] }
        return Array(potentialHand.dropFirst().prefix(5))
    }
    else if (potentialHand.dropFirst().dropFirst().prefix(5).passesForConsecutiveValues {
        $0.value.rawValue - 1 == $1.value.rawValue
    }) {
        guard potentialHand.dropFirst().dropFirst().prefix(5).count == 5 else { return [] }
        return Array(potentialHand.dropFirst().dropFirst().prefix(5))
    }
    return []
}

func getStraightFlush(player: Player, river: [Card]) -> [Card] {
    let flushHand = getFlushCards(player: player, river: river)
    return getStraightHand(player: nil, river: flushHand)
}

func getFourOfAKind(player: Player?, river: [Card]) -> [Card] {
    let potentialHand = getCards(river: river, hand: player?.hand).getOrdered()
    let fourOfAKindValue = potentialHand
        .map { card in
            card.value
        }
        .reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        .filter { (suit, count) in
            count == 4
        }
        .keys
        .first
    
    guard let unwrappedValue = fourOfAKindValue else {
        return []
    }
    
    let fourOfAKindHand = potentialHand.filter { card in
        card.value == unwrappedValue
    }
    let rest = potentialHand.filter { card in
        card.value != unwrappedValue
    }.getOrderedHand()
    
    return Array((fourOfAKindHand.orderBySuit() + rest.orderBySuit()).prefix(5))
}

extension Array where Element == Card {
    func remove(where value: Value) -> [Card] {
        self.filter { $0.value != value }
    }
}
