
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
    
    if let round = x as? Round{
        print("")
        print("Round: \(round.number)")
        print("\(round.players.0.name) draws the \(round.cards.0.value) of \(round.cards.0.suit)")
        print("\(round.players.1.name) draws the \(round.cards.1.value) of \(round.cards.1.suit)")
        print("\(round.winner!.name) wins")
        print("\(round.players.0.name)(\(round.score!.0)) : \(round.players.1.name)(\(round.score!.1))")
    }
    if let war = x as? War{
        print("")
        print("War: \(war.number)")
        print("\(war.players.0.name) draws the \(war.startCards[0].0.value) of \(war.startCards[0].0.value)")
        print("\(war.players.1.name) draws the \(war.startCards[0].1.value) of \(war.startCards[0].1.value)")
        if war.status == "bust"{
            if war.winner!.name == war.players.0.name{
                print("\(war.players.1.name) ran out of cards. \(war.players.0.name) wins the game.")
            } else{
                print("\(war.players.0.name) ran out of cards. \(war.players.1.name) wins the game.")
            }
        } else{
            
        }
        
        print("Players: \(war.players.0.name) and \(war.players.1.name)")
        if war.multiple > 1{
            for i in 0...war.startCards.count-1{
                print("startcards: \(war.startCards[i].0.value) and \(war.startCards[i].1.value)")
            }
        } else {
            print("startcards: \(war.startCards[0].0.value) and \(war.startCards[0].1.value)")
        }
        if war.discards.count > 1{
            for i in 0..<war.discards.count{
                print("Discard: \(war.discards[i].value) of \(war.discards[i].suit)")
            }
        }
        print("Status: \(war.status)")
        if let winner = war.winner{
        print("Winner: \(winner.name)")
        }
        print("Multiple: \(war.multiple)")
        print("Score: \(war.score!.0) and \(war.score!.1)")
        
    }
    
   
   
}
