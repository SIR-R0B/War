class Player {
    class Hand {
        var cards: [Card]
        init(cards: [Card]){
            self.cards = cards
        }
    }
    let name: String
    var hand: Hand
    init(name: String, hand: Hand){
        self.name = name
        self.hand = hand
    }
}


