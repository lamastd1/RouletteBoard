class Player {
  var id: Int
  var startingWallet: Int
  var strategy: Strategy
  var maxRounds: Int // number of rounds this person will play at maximum
  // var scaredWinner: Bool // after 3 consecutive wins, skips the next round
  var soreLoser: Bool // after 3 consecutive losses, quits
  var impatientLoser: Bool // after 3 consecutive losses, goes all in for the strategy they have
  var addict: Bool // when wallet hits 0, if profit is not more than what they started with, switch profit into wallet
  var rounds: [Round]
  var playedBets: [Bet]
  var wallet: Int
  var profit: Int
  var willLeave: Bool

  init(id: Int, startingWallet: Int, strategy: Strategy, maxRounds: Int, /*scaredWinner: Bool,*/ soreLoser: Bool, impatientLoser: Bool, addict: Bool, rounds: [Round], playedBets: [Bet], wallet: Int, profit: Int, willLeave: Bool = false) {
    self.id = id
    self.startingWallet = startingWallet
    self.strategy = strategy
    self.maxRounds = maxRounds
    // self.scaredWinner = scaredWinner
    self.soreLoser = soreLoser
    self.impatientLoser = impatientLoser
    self.addict = addict
    self.rounds = rounds
    self.playedBets = playedBets
    self.wallet = wallet
    self.profit = profit
    self.willLeave = willLeave
  }

  func handleForcedBet(forcedBetAmount: Int) -> Int {
    if (forcedBetAmount == -5) {
      return 0
    } else if (forcedBetAmount != -1) {
      return 1
    } else {
      return 2
    }
  }

  func makeBet(roundNumber: Int, forcedBetAmount: Int) -> Bool {
    
    //print("starting makebet")

    // for bet: Bet in playedBets {
    //   print("1 round number \(roundNumber) bet name \(bet.name) bet size \(bet.amountBet) bet round number \(bet.roundNumber) bet outcome \(bet.outcome)")
    // }

    let k: Int = determineConsecutiveOutcome(outcome: "lost") 
    // // print("k: \(k)")
    // if (k == 0) {
    //   var sumBets: Int = 0
    //   for betSequence: BetSequence in self.strategy.betSequence {
    //     for bet: Bet in betSequence.bets {
    //       sumBets = sumBets + bet.amountBet
    //     }
    //   }  
    //   if (sumBets <= wallet) { 
    //     for betSequence: BetSequence in self.strategy.betSequence {
    //       for var bet: Bet in betSequence.bets {
    //         bet.roundNumber = roundNumber
    //         playedBets.append(bet)
    //       }
    //     }  
    //     return true
    //   } else {
    //     return false
    //   }
    // }

    // for bet: Bet in playedBets {
    //   print("2 round number \(roundNumber) bet name \(bet.name) bet size \(bet.amountBet) bet round number \(bet.roundNumber) bet outcome \(bet.outcome)")
    // }

    var newBet: [Bet] = []
    if (self.strategy.betSequence.count == 1 && self.strategy.betSequence[0].bets.count == 1) {
      newBet.append(self.strategy.betSequence[0].bets[0])
    } else {
      if (self.strategy.betSequence.count > 1 && k > 0) {
        for sequence in self.strategy.betSequence {
          print("consecutive wins: \(sequence.consecutiveWins), k: \(k), count: \(self.strategy.betSequence.count)")
          for bet in sequence.bets {
            print("bet name \(bet.name) bet amount \(bet.amountBet)")
          }
        }
      }
      let usedBetSequences = self.strategy.betSequence.filter { $0.consecutiveWins == (k % (self.strategy.betSequence.count)) }[0]
      for bet: Bet in usedBetSequences.bets {
        newBet.append(bet)
      }
    }
    let forcedBet: Int = handleForcedBet(forcedBetAmount: forcedBetAmount)

    if (forcedBet == 0) {
      return false
    } else if (forcedBet == 1) {
      for var bet: Bet in newBet {
        bet.amountBet = forcedBetAmount / newBet.count
        bet.roundNumber = roundNumber
        bet.force = true
        // print("forcing a bet: \(bet.roundNumber) \(bet.name)")
        playedBets.append(bet)
      }
      return true
    }

    if (playedBets.isEmpty) {
      for var bet: Bet in newBet {
        bet.roundNumber = roundNumber
        playedBets.append(bet)
      }
      return true
    }

   // for bet: Bet in playedBets {
      // if (bet.roundNumber == roundNumber - 1){
      //   print("4 round number \(roundNumber) bet name \(bet.name) bet size \(bet.amountBet) bet round number \(bet.roundNumber) bet outcome \(bet.outcome)")
      // }
   //  }

    var positiveBetAmounts: Int = 0
    var negativeBetAmounts: Int = 0
    let lastRoundBets: [Bet] = self.playedBets.filter { $0.roundNumber == roundNumber - 1 }
    for bet: Bet in lastRoundBets {
      if (bet.outcome == "won") {
        positiveBetAmounts = positiveBetAmounts + bet.amountBet * bet.payout
      } else if (bet.outcome == "lost") {
        negativeBetAmounts = negativeBetAmounts + bet.amountBet
      }
      // print("[pos and neg vals] \(positiveBetAmounts) \(negativeBetAmounts)")
    }
    if (playedBets.last!.force == true) {
      print("current round number: \(roundNumber)")
      for bet in newBet {
        print("new bet: \(bet.name) \(bet.roundNumber)")
      }
      for bet in playedBets {
        print("played bet: \(bet.name) \(bet.roundNumber)")
      }
      print()
    }
    var betsToCopy: [Bet] = []
    for bet: Bet in newBet {
      if (playedBets.last!.force == true) {
//        print("Last bet is a force")
//        print("[bet outcome bet roundnumebr bet name] \(bet.outcome) \(bet.roundNumber) \(bet.name)")
//        print("[played bet outcome and roundnumebr name] \(playedBets.last!.outcome) \(playedBets.last!.roundNumber) \(playedBets.last!.name)")
        var forcedBets = playedBets.filter { $0.roundNumber == roundNumber - 1 }
        var forcedBetsMinus2 = playedBets.filter { $0.name == bet.name }
//        for bet in forcedBets {
//          print("right round in forced bets: \(bet.roundNumber)")
//        }
//        for bet in forcedBetsMinus2 {
//          print("right name in round: \(bet.name)")
//        }
      }
      var betToCopy: Bet = playedBets.filter { $0.name == bet.name && $0.roundNumber == roundNumber - 1 }[0]
      if ((positiveBetAmounts <= negativeBetAmounts && strategy.increaseOnWin == false) || (positiveBetAmounts > negativeBetAmounts && strategy.increaseOnWin == true)) { // treat this like a overall win
        if (strategy.bettingStyle == "fibonacci") {
          if (playedBets.last!.force == true) {
            betToCopy.amountBet = strategy.generateNextFibonacci(prevNum: self.strategy.betSequence[0].bets[0].amountBet)
            betToCopy.roundNumber = roundNumber
          } else {
            betToCopy.amountBet = strategy.generateNextFibonacci(prevNum: betToCopy.amountBet)
            betToCopy.roundNumber = roundNumber
          }
        } else if (strategy.bettingStyle == "martingale") {
          betToCopy.amountBet = strategy.generateNextMartingale(num1: betToCopy.amountBet)
          betToCopy.roundNumber = roundNumber
        } else if (strategy.bettingStyle == "minimumNetGain") {
          betToCopy.amountBet = strategy.generateNextMinimumNetGain(prevNum: betToCopy.amountBet)
          betToCopy.roundNumber = roundNumber
        } 
        betToCopy.roundNumber = roundNumber
      } else {
        var sumBets: Int = 0
        for betSequence: BetSequence in self.strategy.betSequence {
          for bet: Bet in betSequence.bets {
            sumBets = sumBets + bet.amountBet
          }
        }  
        if (sumBets <= wallet) { 
          for betSequence: BetSequence in self.strategy.betSequence {
            for var bet: Bet in betSequence.bets {
              bet.roundNumber = roundNumber
              playedBets.append(bet)
            }
          }  
          return true
        } else {
          return false
        }
      } 
      betsToCopy.append(betToCopy)
    }
    // print("amounts made")
    var sumBets: Int = 0
    for bet: Bet in betsToCopy {
      sumBets = sumBets + bet.amountBet
    }
    if (sumBets <= wallet) {
      for var bet: Bet in betsToCopy {
        bet.roundNumber = roundNumber
        playedBets.append(bet)
      }   
      return true
    } else {
      return false
    }
  }

  func getAverageBet() -> Int {
    var sum: Int = 0
    for bet: Bet in playedBets {
      sum = sum + bet.amountBet
    }
    return (sum / rounds.count)
  }

  func getDefaultStartingBetSize() -> Int {
    var sum: Int = 0
    for bet: Bet in strategy.betSequence[0].bets {
      sum = sum + bet.amountBet
    }
    return sum
  }

  func getDefaultStartingBetNames() -> String {
    var names: String = ""
    for bet: Bet in strategy.betSequence[0].bets {
      names = names + bet.name + "&"
    }
    return names
  }

  func determineConsecutiveOutcome(outcome: String) -> Int {
    // print("determine outcome starting")
    var consecutiveWins: Int = 0
    if (rounds.count == 0) {
      return 0
    } else {
      for i: Int in stride(from: rounds.count - 1, through: 0, by: -1) {
        let currentBets: [Bet] = playedBets.filter { $0.roundNumber == rounds[i].roundNumber }
        var sumBets: Int = 0
        for bet: Bet in currentBets {
          // print("bet name \(bet.name) bet outcome \(bet.outcome)")
          if (bet.outcome == outcome) {
            sumBets = bet.amountBet * (bet.payout - 1)
          } else {
            sumBets = sumBets - bet.amountBet
          }
        }
        if (sumBets > 0) {
          // print("sumbets \(sumBets)")
          consecutiveWins = consecutiveWins + 1
        } else {
          break
        }
      }
    }
    // print("determine outcome ending")
    return consecutiveWins
  }
}
