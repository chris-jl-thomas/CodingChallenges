import Foundation

func getFourOfAKind(player: Player?, river: [Card]) -> [Card] {
    let potentialHand = getCards(river: river, hand: player?.hand)
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
