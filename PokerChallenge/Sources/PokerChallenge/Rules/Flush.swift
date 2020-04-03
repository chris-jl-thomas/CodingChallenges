import Foundation

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
