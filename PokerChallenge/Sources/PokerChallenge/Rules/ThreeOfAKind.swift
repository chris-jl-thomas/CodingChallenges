import Foundation

func getThreeOfAKindHand(player: Player?, river: [Card]) -> [Card] {
    let potentialHand = getCards(river: river, hand: player?.hand)
    let threeOfAKindValues = potentialHand
        .map { card in
            card.value
        }
        .reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        .filter { (suit, count) in
            count == 3
        }
        .keys
    
    guard threeOfAKindValues.count > 0 else { return [] }
    
    var highestValue: Value = .Two
    var lowestValue: Value = .Ace
    threeOfAKindValues
        .forEach { value in
            highestValue = value.rawValue > highestValue.rawValue ? value : highestValue
            lowestValue = value.rawValue < lowestValue.rawValue ? value : lowestValue
        }
    
    let threeOfAKindCards = potentialHand
        .filter { card in
            card.value == highestValue
        }
        .orderBySuit()
    
    let rest = potentialHand
        .filter { card in
            card.value != highestValue
        }
        .getOrderedHand()
    
    return Array(
        (threeOfAKindCards + rest).prefix(5)
    )
}
