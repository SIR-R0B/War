// MARK: Controller
// Controller controller prepares the data to play a game, creates all cards from enums
func buildDeck() -> [Card]{
    var result = [Card]()
    for i in Suit.allCases {
        for j in 2...14{
            result.append(Card(value: Value(rawValue: j)!, suit: i))
        }
    }
    return result
}

var deck = Deck(cards: buildDeck())
let deckSize = deck.cards.count

func deal(_ deck: Deck) -> ([Card],[Card]) {
    var firstHalf = Deck(cards: [])
    var secondHalf = Deck(cards: [])
    
    while(firstHalf.cards.count + secondHalf.cards.count != deckSize){
        let deal = Int.random(in: 0..<deckSize)
        if firstHalf.cards.contains(where: {card in if card.value == deck.cards[deal].value, card.suit == deck.cards[deal].suit {return true}; return false}) == false && secondHalf.cards.contains(where: {card in if card.value == deck.cards[deal].value, card.suit == deck.cards[deal].suit {return true}; return false}) == false{
            if Int.random(in: 1...2) == 1 && firstHalf.cards.count < 26{
                firstHalf.cards.append(deck.cards[deal])
            } else{
                if secondHalf.cards.count < 26{
                    secondHalf.cards.append(deck.cards[deal])
                }
            }
        }
    }
    let result = (firstHalf.cards,secondHalf.cards)
    return result
}

// MARK: Get User Input
// controller talks to view through getName, gets user input, and then updates model

let player1 = Player(name: getName(1))
let player2 = Player(name: getName(2))

// MARK: Deal
// controller assigns cards dealt to player hands randomly

let cardsDealt = deal(deck)
var p1Hand = Hand(cards: cardsDealt.0)
var p2Hand = Hand(cards: cardsDealt.1)

// MARK: Start the game

let game = Game(players: (player1, player2), hands: (p1Hand, p2Hand), status: "active")

var roundNumber = 1
var warNumber = 1

while game.status == "active"{
    
    if game.hands.0.cards.count == 0 || game.hands.1.cards.count == 0{
        game.status = "finished"
        break
    }
    // MARK: Start a round
    let round = Round(players: (player1, player2), cards: (game.hands.0.cards.removeFirst(),game.hands.1.cards.removeFirst()), status: "active", number: roundNumber)
    let p1DrawCard = round.cards.0
    let p2DrawCard = round.cards.1
    
    if p1DrawCard.value.rawValue == p2DrawCard.value.rawValue{
        
        round.isWar = true
        
        let war = War(players: (player1, player2), compareCards: [(p1DrawCard, p2DrawCard)], discards: [p1DrawCard,p2DrawCard], status: "active", multiple: 1, number: warNumber)
        
        while war.status == "active"{
            
            if game.hands.0.cards.count > 3 && game.hands.1.cards.count > 3{
                
                let p1Discard1 = game.hands.0.cards.removeFirst()
                let p1Discard2 = game.hands.0.cards.removeFirst()
                let p1Discard3 = game.hands.0.cards.removeFirst()
                let p2Discard1 = game.hands.1.cards.removeFirst()
                let p2Discard2 = game.hands.1.cards.removeFirst()
                let p2Discard3 = game.hands.1.cards.removeFirst()
                
                war.discards += [p1Discard1, p2Discard1, p1Discard2, p2Discard2, p1Discard3, p2Discard3]
                
                war.cards = (game.hands.0.cards.removeFirst(),game.hands.1.cards.removeFirst())
                war.compareCards.append(war.cards!)
                
                switch war.cards!{
                case let p1 where p1.0.value.rawValue > war.cards!.1.value.rawValue:
                    war.winner = player1
                    war.status = "finished"
                    game.hands.0.cards += war.discards
                    game.hands.0.cards.append(war.cards!.0)
                    game.hands.0.cards.append(war.cards!.1)
                    
                case let p2 where p2.1.value.rawValue > war.cards!.0.value.rawValue:
                    war.winner = player2
                    war.status = "finished"
                    game.hands.1.cards += war.discards
                    game.hands.1.cards.append(war.cards!.0)
                    game.hands.1.cards.append(war.cards!.1)
                    
                default:
                    war.discards.append(war.cards!.0)
                    war.discards.append(war.cards!.1)
                    war.multiple += 1
                }
                
            } else {
                // War, but not enough cards, so gameover
                // if war.multiple >1 the original drawCards will have already been added to the discard pile, otherwise no
                if game.hands.0.cards.count < 4{
                    if war.multiple > 1{
                        game.hands.1.cards += war.discards
                    } else{
                        game.hands.1.cards.append(p1DrawCard)
                        game.hands.1.cards.append(p2DrawCard)
                    }
                    for _ in 0..<game.hands.0.cards.count{
                        game.hands.1.cards.append(game.hands.0.cards.removeFirst())
                        war.winner = player2
                    }
                }
                if game.hands.1.cards.count < 4{
                    // if war.multiple >1 the original drawCards will have already been added to the discard pile, otherwise no
                    if war.multiple > 1{
                        game.hands.0.cards += war.discards
                    } else{
                        game.hands.0.cards.append(p1DrawCard)
                        game.hands.0.cards.append(p2DrawCard)
                    }
                    for _ in 0..<game.hands.1.cards.count{
                        game.hands.0.cards.append(game.hands.1.cards.removeFirst())
                        war.winner = player1
                    }
                }
                war.status = "bust"
            }
            war.score = (game.hands.0.cards.count,game.hands.1.cards.count)
                if war.winner != nil{
                    display(war)
                    war.discards = []
                }
        }
        warNumber += 1
    } else {
        
        round.isWar = false
        
        if p1DrawCard.value.rawValue > p2DrawCard.value.rawValue{
            // randomness is used here to simulate the randomness in which cards are picked up and added to the bottom of winner's deck
            if Int.random(in: 1...2) == 1{
                game.hands.0.cards.append(p1DrawCard)
                game.hands.0.cards.append(p2DrawCard)
            }else{
                game.hands.0.cards.append(p2DrawCard)
                game.hands.0.cards.append(p1DrawCard)
            }
            round.winner = player1
        } else{
            if p2DrawCard.value.rawValue > p1DrawCard.value.rawValue{
                if Int.random(in: 1...2) == 2{
                    game.hands.1.cards.append(p2DrawCard)
                    game.hands.1.cards.append(p1DrawCard)
                } else{
                    game.hands.1.cards.append(p1DrawCard)
                    game.hands.1.cards.append(p2DrawCard)
                }
            }
           round.winner = player2
        }
    }
    round.status = "finished"
    round.score = (game.hands.0.cards.count,game.hands.1.cards.count)
    if round.isWar == false{
    display(round)
    roundNumber += 1
    }
}
//game is over, report out the winner/loser
display(game)


