struct Deck {
    var cards: [Card]{
        var result = [Card]()
        for i in Card.Suit.allCases {
            for j in 2...14{
                result.append(Card(value: Card.Value(rawValue: j)!, suit: i))
            }
        }
        return result
    }
    var size: Int{
        return cards.count
    }
    func deal() -> ([Card],[Card]) {
        var firstHalf = [Card]()
        var secondHalf = [Card]()
        while(firstHalf.count + secondHalf.count != size){
            let deal = Int.random(in: 0..<size)
            if firstHalf.contains(where: {card in if card.value == cards[deal].value, card.suit == cards[deal].suit {return true}; return false}) == false && secondHalf.contains(where: {card in if card.value == cards[deal].value, card.suit == cards[deal].suit {return true}; return false}) == false{
                if Int.random(in: 1...2) == 1 && firstHalf.count < size/2{
                    firstHalf.append(cards[deal])
                } else{
                    if secondHalf.count < size/2{
                        secondHalf.append(cards[deal])
                    }
                }
            }
        }
        let result = (firstHalf,secondHalf)
        return result
    }
}
