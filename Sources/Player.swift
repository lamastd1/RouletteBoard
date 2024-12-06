class Player {
  var id: Int
  var startingWallet: Int
  var strategy: Strategy
  var maxRounds: Int // number of rounds this person will play at maximum
  var soreLoser: Bool // after 3 consecutive losses, quits
  var impatientLoser: Bool // after 3 consecutive losses, goes all in for the strategy they have
  var addict: Bool // when wallet hits 0, if profit is not more than what they started with, switch profit into wallet
  var rounds: [Round] // array that holds the rounds a player played in
  var playedBets: [Bet] // holds the bets that the player placed
  var wallet: Int // holds the players current wallet amount
  var profit: Int // holds the players profit
  var willLeave: Bool // true if the player can't continue

  init(id: Int, startingWallet: Int, strategy: Strategy, maxRounds: Int, soreLoser: Bool, impatientLoser: Bool, addict: Bool, rounds: [Round], playedBets: [Bet], wallet: Int, profit: Int, willLeave: Bool = false) {
    self.id = id
    self.startingWallet = startingWallet
    self.strategy = strategy
    self.maxRounds = maxRounds
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

    let k: Int = determineConsecutiveOutcome(outcome: "lost") 

    var newBet: [Bet] = []
    if (self.strategy.betSequence.count == 1 && self.strategy.betSequence[0].bets.count == 1) {
      newBet.append(self.strategy.betSequence[0].bets[0])
    } else {
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

    var positiveBetAmounts: Int = 0
    var negativeBetAmounts: Int = 0
    let lastRoundBets: [Bet] = self.playedBets.filter { $0.roundNumber == roundNumber - 1 }
    for bet: Bet in lastRoundBets {
      if (bet.outcome == "won") {
        positiveBetAmounts = positiveBetAmounts + bet.amountBet * bet.payout
      } else if (bet.outcome == "lost") {
        negativeBetAmounts = negativeBetAmounts + bet.amountBet
      }
    }

    var betsToCopy: [Bet] = []
    for bet: Bet in newBet {
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
    var consecutiveWins: Int = 0
    if (rounds.count == 0) {
      return 0
    } else {
      for i: Int in stride(from: rounds.count - 1, through: 0, by: -1) {
        let currentBets: [Bet] = playedBets.filter { $0.roundNumber == rounds[i].roundNumber }
        var sumBets: Int = 0
        for bet: Bet in currentBets {
          if (bet.outcome == outcome) {
            sumBets = bet.amountBet * (bet.payout - 1)
          } else {
            sumBets = sumBets - bet.amountBet
          }
        }
        if (sumBets > 0) {
          consecutiveWins = consecutiveWins + 1
        } else {
          break
        }
      }
    }
    return consecutiveWins
  }
}
