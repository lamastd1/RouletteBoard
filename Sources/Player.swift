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
  var bets: [Bet]
  var wallet: Int
  var profit: Int
  var willLeave: Bool

  init(id: Int, startingWallet: Int, strategy: Strategy, maxRounds: Int, /*scaredWinner: Bool,*/ soreLoser: Bool, impatientLoser: Bool, addict: Bool, rounds: [Round], bets: [Bet], wallet: Int, profit: Int, willLeave: Bool = false) {
    self.id = id
    self.startingWallet = startingWallet
    self.strategy = strategy
    self.maxRounds = maxRounds
    // self.scaredWinner = scaredWinner
    self.soreLoser = soreLoser
    self.impatientLoser = impatientLoser
    self.addict = addict
    self.rounds = rounds
    self.bets = bets
    self.wallet = wallet
    self.profit = profit
    self.willLeave = willLeave
  }

  func makeBet(roundNumber: Int, forcedBetAmount: Int) -> Bool {
    return (strategy.makeBet(bets: &self.bets, wallet: self.wallet, roundNumber: roundNumber, forcedBetAmount: forcedBetAmount))
  }

  func getAverageBet() -> Int {
    var sum: Int = 0
    for bet: Bet in bets {
      sum = sum + bet.amountBet
    }
    return (sum / rounds.count)
  }

  func determineConsecutiveOutcome(numRounds: Int, outcome: Bool) -> Bool {
    var eachRound: [Bool] = []
    if (rounds.count < numRounds) {
      return false
    } else {
      for i: Int in stride(from: rounds.count - 1, through: rounds.count - numRounds, by: -1) {
        let currentBets: [Bet] = bets.filter { $0.roundNumber == rounds[i].roundNumber }
        var sumBets: Int = 0
        for bet: Bet in currentBets {
          let hasPiece: Bool = bet.affectedPieces.contains { piece in
            piece.color == rounds[i].piece.color && piece.value == rounds[i].piece.value
          }
          if hasPiece {
            sumBets = bet.amountBet * (bet.payout - 1)
          } else {
            sumBets = sumBets - bet.amountBet
          }
        }
        if (sumBets > 0) {
          // print("true \(rounds[i].piece.description)")
          eachRound.append(true)
          // print("Sumbets: \(sumBets)")
        } else {
          // print("false \(rounds[i].piece.description)")
          if (rounds[i].piece.color == "red") {
           //  print("Sumbets: \(sumBets)")
          }
          eachRound.append(false)
        }
      }
      print()
    }
    return eachRound.allSatisfy { $0 == outcome }
  }
}