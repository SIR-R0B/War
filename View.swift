
// MARK: Terminal view
func getName(_ n : Int) -> String{
    print("Input Player\(n) name: ")
    if let input = readLine(), input != ""{
        return input
    } else{
        return "Player\(n)"
    }
}
func display(_ x: Any) -> (){
    if let game = x as? Game{
        print("Game status: \(game.status)")
        print("\(game.players.0.name)(\(game.hands.0.cards.count))")
        print("\(game.players.1.name)(\(game.hands.1.cards.count))")
    }
    if let round = x as? Round{
        print("")
        print("Round: \(round.number)")
        print("\(round.players.0.name) draws the \(round.cards.0.value) of \(round.cards.0.suit)")
        print("\(round.players.1.name) draws the \(round.cards.1.value) of \(round.cards.1.suit)")
        print("Winner: \(round.winner!.name)")
        print("\(round.players.0.name)(\(round.score!.0)) : \(round.players.1.name)(\(round.score!.1))")
    }
    if let war = x as? War{
        print("")
        print("War: \(war.number)")
        print("\(war.players.0.name) draws the \(war.compareCards[0].0.value) of \(war.compareCards[0].0.suit)")
        print("\(war.players.1.name) draws the \(war.compareCards[0].1.value) of \(war.compareCards[0].1.suit)")
        if war.status == "bust"{
            if war.multiple > 1{
                //bust after at least one round of war
                for i in 1...war.compareCards.count-1{
                    print("Both players draw 3 cards...")
                    print("\(war.players.0.name) draws the \(war.compareCards[i].0.value) of \(war.compareCards[i].0.suit)")
                    print("\(war.players.1.name) draws the \(war.compareCards[i].1.value) of \(war.compareCards[i].1.suit)")
                }
                if let winner = war.winner{
                    print("\(winner.name) wins:")
                    for i in 0..<war.discards.count{
                        print("\(war.discards[i].value) of \(war.discards[i].suit)")
                    }
                }
            } else{
                // war multiple == 1 and bust
                if war.winner!.name == war.players.0.name{
                    print("\(war.players.1.name) ran out of cards. \(war.players.0.name) wins the game.")
                } else{
                    print("\(war.players.0.name) ran out of cards. \(war.players.1.name) wins the game.")
                }
            }
        } else{
            //war status is not bust
            for i in 1...war.compareCards.count-1{
                print("Both players draw 3 cards...")
                print("\(war.players.0.name) draws the \(war.compareCards[i].0.value) of \(war.compareCards[i].0.suit)")
                print("\(war.players.1.name) draws the \(war.compareCards[i].1.value) of \(war.compareCards[i].1.suit)")
            }
            if let winner = war.winner{
                print("\(winner.name) wins:")
                for i in 0..<war.discards.count{
                    print("\(war.discards[i].value) of \(war.discards[i].suit)")
                }
            }
        }
        print("Score: \(war.score!.0) and \(war.score!.1)")
    }
}
