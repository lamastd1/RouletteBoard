class Player {
  var id: Int
  var startingWallet: Int
  var maxRounds: Int
  var strategy: Strategy
  var rounds: [Round]
  var bets: [Bet]
  var wallet: Int
  var profit: Int

  init(id: Int, startingWallet: Int, maxRounds: Int, strategy: Strategy, rounds: [Round], bets: [Bet], wallet: Int, profit: Int) {
    self.id = id
    self.startingWallet = startingWallet
    self.maxRounds = maxRounds
    self.strategy = strategy
    self.rounds = rounds
    self.bets = bets
    self.wallet = wallet
    self.profit = profit
  }

  func makeBet(roundNumber: Int) -> Bool {
    return (strategy.makeBet(bets: &self.bets, wallet: self.wallet, roundNumber: roundNumber))
  }

  // func getAverageBet() {
  //   for round: Round in rounds {
  //     bet.
  //   }
  // }
}