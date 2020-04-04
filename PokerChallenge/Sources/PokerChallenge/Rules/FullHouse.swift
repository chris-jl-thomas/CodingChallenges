import Foundation

func getFullHouseHand(player: Player?, river: [Card]) -> [Card] {
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
    
    if threeOfAKindValues.count == 2 {
        let pairCards = potentialHand
            .filter { card in
                card.value == lowestValue
            }
            .getOrdered()
            .prefix(2)
        
        return threeOfAKindCards + pairCards
    }
    
    let rest = potentialHand.filter { card in
        card.value != highestValue
    }
    
    let pairKeys = rest.map { card in
        card.value
    }
    .reduce(into: [:]) { counts, number in
        counts[number, default: 0] += 1
    }
    .filter { (suit, count) in
        count == 2
    }
    
    guard pairKeys.count > 0 else { return [] }
    
    highestValue = .Two
    lowestValue = .Ace
    pairKeys
        .forEach { (key, value) in
            highestValue = key.rawValue > highestValue.rawValue ? key : highestValue
            lowestValue = key.rawValue < lowestValue.rawValue ? key : lowestValue
        }
    
    let pair = potentialHand.filter { card in
            card.value == highestValue
        }
        .orderBySuit()
    return threeOfAKindCards + pair
    
}
