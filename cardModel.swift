class Card {
    enum Value: Int {
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace
    }
    enum Suit: CaseIterable {
        case Hearts, Clubs, Spades, Diamonds
    }
    let value: Value
    let suit: Suit
    init(value: Value, suit: Suit){
        self.value = value
        self.suit = suit
    }
}
