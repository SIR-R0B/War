class Game {
    enum Status {
        case active, finished, bust
    }
    class War {
        let players: (Player, Player)
        var compareCards: [(Card,Card)]
        var discards: [Card]
        var cards: (Card,Card)?
        var status = Status.active
        var winner: Player?
        var multiple: Int
        var number: Int
        var score: (Int,Int)?
        let drawAmt = 3
        var isBust: Bool{
            return status == Status.bust
        }
        init(players: (Player, Player), compareCards: [(Card,Card)], discards: [Card], multiple: Int, number: Int){
            self.players = players
            self.compareCards = compareCards
            self.discards = discards
            self.multiple = multiple
            self.number = number
        }
    }
    class Round {
        let players: (Player, Player)
        let cards: (Card, Card)
        var status = Status.active
        var number: Int
        var winner: Player?
        var score: (Int,Int)?
        var isWar = false
        init(players: (Player, Player), cards: (Card, Card), number: Int){
            self.players = players
            self.cards = cards
            self.number = number
        }
    }
    var player1Busts: Bool{
        return players.0.hand.cards.count == 0
    }
    var player2Busts: Bool{
        return players.1.hand.cards.count == 0
    }
    var status = Status.active
    let players: (Player, Player)
    var log: [Any]
    init(players: (Player, Player), log: [Any]){
        self.players = players
        self.log = log
    }
    func play(){
        
        var roundNumber = 1
        var warNumber = 1
        
        while status == Status.active{
            
            if player1Busts || player2Busts{
                status = Status.finished
                break
            }
            // MARK: Start a round
            let round = Round(players: (player1, player2), cards: (players.0.hand.cards.removeFirst(),players.1.hand.cards.removeFirst()), number: roundNumber)
            let p1DrawCard = round.cards.0
            let p2DrawCard = round.cards.1
            
            if p1DrawCard.value.rawValue == p2DrawCard.value.rawValue{
                
                round.isWar = true
                
                let war = War(players: (player1, player2), compareCards: [(p1DrawCard, p2DrawCard)], discards: [p1DrawCard,p2DrawCard], multiple: 1, number: warNumber)
                
                while war.status == Status.active{
                    
                    if players.0.hand.cards.count > war.drawAmt && players.1.hand.cards.count > war.drawAmt{
                        
                        for _ in 0..<war.drawAmt{
                            let discard = players.0.hand.cards.removeFirst()
                            war.discards.append(discard)
                        }
                        for _ in 0..<war.drawAmt{
                            let discard = players.1.hand.cards.removeFirst()
                            war.discards.append(discard)
                        }
                        war.cards = (players.0.hand.cards.removeFirst(),players.1.hand.cards.removeFirst())
                        war.compareCards.append(war.cards!)
                        switch war.cards!{
                        case let p1 where p1.0.value.rawValue > war.cards!.1.value.rawValue:
                            war.winner = player1
                            war.status = Status.finished
                            players.0.hand.cards += war.discards
                            players.0.hand.cards.append(war.cards!.0)
                            players.0.hand.cards.append(war.cards!.1)
                            
                        case let p2 where p2.1.value.rawValue > war.cards!.0.value.rawValue:
                            war.winner = player2
                            war.status = Status.finished
                            players.1.hand.cards += war.discards
                            players.1.hand.cards.append(war.cards!.0)
                            players.1.hand.cards.append(war.cards!.1)
                            
                        default:
                            war.discards.append(war.cards!.0)
                            war.discards.append(war.cards!.1)
                            war.multiple += 1
                        }
                    } else {
                        // War, but not enough cards, so gameover. If war.multiple >1 the original drawCards will have already been added to the discard pile, otherwise no
                        if players.0.hand.cards.count <= war.drawAmt{
                            if war.multiple > 1{
                                players.1.hand.cards += war.discards
                            } else{
                                players.1.hand.cards.append(p1DrawCard)
                                players.1.hand.cards.append(p2DrawCard)
                            }
                            for _ in 0..<players.0.hand.cards.count{
                                players.1.hand.cards.append(players.0.hand.cards.removeFirst())
                                war.winner = player2
                            }
                        }
                        if players.1.hand.cards.count < war.drawAmt{
                            // if war.multiple >1 the original drawCards will have already been added to the discard pile, otherwise no
                            if war.multiple > 1{
                                players.0.hand.cards += war.discards
                            } else{
                                players.0.hand.cards.append(p1DrawCard)
                                players.0.hand.cards.append(p2DrawCard)
                            }
                            for _ in 0..<players.1.hand.cards.count{
                                players.0.hand.cards.append(players.1.hand.cards.removeFirst())
                                war.winner = player1
                            }
                        }
                        war.status = Status.bust
                    }
                    war.score = (players.0.hand.cards.count,players.1.hand.cards.count)
                    if war.winner != nil{
                        log.append(war)
                    }
                }
                warNumber += 1
            } else {
                round.isWar = false
                if p1DrawCard.value.rawValue > p2DrawCard.value.rawValue{
                    // randomness is used here to simulate the randomness in which cards are picked up and added to the bottom of winner's deck
                    if Int.random(in: 1...2) == 1{
                        players.0.hand.cards.append(p1DrawCard)
                        players.0.hand.cards.append(p2DrawCard)
                    }else{
                        players.0.hand.cards.append(p2DrawCard)
                        players.0.hand.cards.append(p1DrawCard)
                    }
                    round.winner = player1
                } else{
                    if p2DrawCard.value.rawValue > p1DrawCard.value.rawValue{
                        if Int.random(in: 1...2) == 2{
                            players.1.hand.cards.append(p2DrawCard)
                            players.1.hand.cards.append(p1DrawCard)
                        } else{
                            players.1.hand.cards.append(p1DrawCard)
                            players.1.hand.cards.append(p2DrawCard)
                        }
                    }
                    round.winner = player2
                }
            }
            round.status = Status.finished
            round.score = (players.0.hand.cards.count,players.1.hand.cards.count)
            if round.isWar == false{
                log.append(round)
                roundNumber += 1
            }
        }
    }
}
