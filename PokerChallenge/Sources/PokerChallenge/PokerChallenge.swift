func decideWinner(players: [Player], river: [Card]) {

}

func getCards(river: [Card], hand: [Card]?) -> [Card] {
    return river + (hand ?? [])
}
