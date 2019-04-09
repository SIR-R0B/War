// MARK: Controller
var deck = Deck()
let player1 = Player(name: getName(1), hand: Player.Hand(cards: deck.deal().firstHalf))
let player2 = Player(name: getName(2), hand: Player.Hand(cards: deck.deal().secondHalf))
let game = Game(players: (player1, player2), log: [])
game.play()
display(game)
