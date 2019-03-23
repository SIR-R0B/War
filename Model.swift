enum Value: Int {
    case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace
}
enum Suit: CaseIterable {
    case Hearts, Clubs, Spades, Diamonds
}
class Card {
    let value: Value
    let suit: Suit
    init(value: Value, suit: Suit){
        self.value = value
        self.suit = suit
    }
}
struct Deck {
    var cards: [Card]
}
class Hand {
    let owner: Player
    var count: Int
    var cards: [Card]
    init(owner: Player, count: Int, cards: [Card]){
        self.owner = owner
        self.count = count
        self.cards = cards
    }
}
class Player {
    let name: String
    init(name: String){
        self.name = name
    }
}
class Game {
    var hands: (Hand, Hand)
    var status: String //active, finished
    init(hands: (Hand, Hand), status: String){
        self.hands = hands
        self.status = status
    }
}
class War {
    let players: (Player, Player)
    var startCards: [(Card,Card)]
    var discards: [Card]
    var cards: (Card,Card)?
    var status: String //active, finished
    var winner: Player?
    var multiple: Int
    var number: Int
    var score: (Int,Int)?
    init(players: (Player, Player), startCards: [(Card,Card)], discards: [Card], status: String, multiple: Int, number: Int){
        self.players = players
        self.startCards = startCards
        self.discards = discards
        self.status = status
        self.multiple = multiple
        self.number = number
    }
}
class Round {
    let players: (Player, Player)
    let cards: (Card, Card)
    var status: String //active, finished, war
    var number: Int
    var winner: Player?
    var score: (Int,Int)?
    var isWar = false
    init(players: (Player, Player), cards: (Card, Card), status: String, number: Int){
        self.players = players
        self.cards = cards
        self.status = status
        self.number = number
    }
}
