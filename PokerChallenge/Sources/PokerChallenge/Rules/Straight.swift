import Foundation

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
