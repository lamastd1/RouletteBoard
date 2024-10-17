class Strategy {

  var gameNumber: Int
  struct Round {
    var roundNumber: Int
    var bet: BetPlacement 
    var outcome: Bool

    init(roundNumber: Int = 0, bet: BetPlacement, outcome: Bool) {
        self.roundNumber = roundNumber
        self.bet = bet
        self.outcome = outcome
    }
  }
  var rounds: [Round]
  var wallet: Int
  var startingWallet: Int
  var profit: Int
  var increaseOnWin: Bool

  init(gameNumber :Int, rounds: [Round], wallet: Int = 500, profit: Int = 0, increaseOnWin: Bool) {
    self.gameNumber = gameNumber
    self.rounds = rounds
    self.startingWallet = wallet
    self.wallet = wallet
    self.profit = profit
    self.increaseOnWin = increaseOnWin
  }

  func makeBet(roundNumber: Int) {
    
  }

  func description() -> String {
    return ""
  }
}