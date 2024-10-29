class Strategy {
  
  var prevRound: Round
  var currRound: Round
  var increaseOnWin: Bool
  var bettingStyle: String
  var betSequence: [BetSequence]


  init(prevRound: Round, currRound: Round, increaseOnWin: Bool, bettingStyle: String, betSequence: [BetSequence]) {
    self.prevRound = prevRound
    self.currRound = currRound
    self.increaseOnWin = increaseOnWin
    self.bettingStyle = bettingStyle
    self.betSequence = betSequence
  }

  // func makeBet(bets: inout [Bet], wallet: Int, roundNumber: Int, forcedBetAmount: Int) -> Bool {

  //   var reds: [Bet] = betPlacements.filter{ $0.name == "reds" } 

  //   if (forcedBetAmount == -5) {
  //     return false
  //   }
  //   if (forcedBetAmount != -1) {
  //     reds[0].amountBet = forcedBetAmount
  //     reds[0].roundNumber = roundNumber
  //     reds[0].force = true
  //     bets.append(reds[0])
  //     return true
  //   }

  //   if !bets.isEmpty { 
  //     for bet: Bet in bets {
  //       if (bet.roundNumber == roundNumber - 1) {
  //         var prevOutcomeWin: Bool = false
  //         if (bet.force == true) {
  //           print("bet force is true")
  //           prevOutcomeWin = true
  //         }
  //         if (wonBet(bet: bet, prev: true) == true) {
  //           reds[0].amountBet = 5
  //           reds[0].roundNumber = roundNumber
  //           prevOutcomeWin = true
  //         }
  //         if (prevOutcomeWin == false && bets[0].amountBet != 0) {
  //           reds[0].amountBet = generateNextFibonacci(prevNum: bet.amountBet)
  //           reds[0].roundNumber = roundNumber
  //         }
  //       }
  //     }
  //   } else {
  //     reds[0].amountBet = 5
  //     reds[0].roundNumber = roundNumber
  //   }
  //   if (reds[0].amountBet < wallet) {
  //     bets.append(reds[0])
  //     return true
  //   } else {
  //     return false
  //   }
  // }

  // func makeMartingaleBet(bets: inout [Bet], wallet: Int, roundNumber: Int, forcedBetAmount: Int) -> Bool {

  //   // this strategy calls for betting on red every time and creates a copy of the default red bet
  //   var reds: [Bet] = betPlacements.filter{ $0.name == "reds" }

  //   if (forcedBetAmount == -5) {
  //     return false
  //   }
  //   if (forcedBetAmount != -1) {
  //     reds[0].amountBet = forcedBetAmount
  //     reds[0].roundNumber = roundNumber
  //     reds[0].force = true
  //     bets.append(reds[0])
  //     return true
  //   }

  //   if !bets.isEmpty { 
  //     for bet: Bet in bets {
  //       if (bet.roundNumber == roundNumber - 1) {
  //         var prevOutcomeWin: Bool = false
  //         if (bet.force == true) {
  //           print("bet force is true")
  //           prevOutcomeWin = true
  //         }
  //         if (wonBet(bet: bet, prev: true) == true) {
  //           reds[0].amountBet = 5
  //           reds[0].roundNumber = roundNumber
  //           prevOutcomeWin = true
  //         }
  //         if (prevOutcomeWin == false && bets[0].amountBet != 0) {
  //           reds[0].amountBet = generateNextMartingale(num1: bet.amountBet)
  //           reds[0].roundNumber = roundNumber
  //         }
  //       }
  //     }
  //   } else {
  //     reds[0].amountBet = 5
  //     reds[0].roundNumber = roundNumber
  //   }
  //   if (reds[0].amountBet < wallet) {
  //     bets.append(reds[0])
  //     return true
  //   } else {
  //     return false
  //   }
  // }

  func description() -> String {
    return ""
  }

  func wonBet(bet: Bet, prev: Bool) -> Bool {
    for affectedPiece: Piece in bet.affectedPieces {
      if (prev == true) {
        if (affectedPiece.color == prevRound.piece.color && affectedPiece.value == prevRound.piece.value) {
          return true
        }
      } else {
        if (affectedPiece.color == currRound.piece.color && affectedPiece.value == currRound.piece.value) {
          return true
        }
      }
    }
    return false
  }

  func generateNextFibonacci(prevNum: Int) -> Int {
    var num1: Int = 2
    var num2: Int = 3
    var temp: Int = 0
    while(num1 + num2 != prevNum) {
       temp = num2
       num2 = num1 + num2
       num1 = temp
    }
    return prevNum + num2
  }

  func generateNextMartingale(num1: Int) -> Int {
    return num1 * 2
  }

  func generateNextMinimumNetGain(prevNum: Int) -> Int {
    if prevNum == 5 {
        return 6
    } else {
        return prevNum * 2
    }
  }
}
