class Player {
  var name: String
  var startingWallet: Int
  var maxRounds: Int
  var strategy: Strategy
  var rounds: [Round]
  var bets: [Bet]
  var wallet: Int
  var profit: Int

  init(name: String, startingWallet: Int, maxRounds: Int, strategy: Strategy, rounds: [Round], bets: [Bet], wallet: Int, profit: Int) {
    self.name = name
    self.startingWallet = startingWallet
    self.maxRounds = maxRounds
    self.strategy = strategy
    self.rounds = rounds
    self.bets = bets
    self.wallet = wallet
    self.profit = profit
  }

  func makeBet() {
    strategy.makeBet(bets: &self.bets, wallet: &self.wallet)
  }
}