func decideWinner(players: [Player], river: [Card]) {

}

func getCards(river: [Card], hand: [Card]?) -> [Card] {
    return river + (hand ?? [])
}

extension Array where Element == Card {
    func remove(where value: Value) -> [Card] {
        self.filter { $0.value != value }
    }
}
