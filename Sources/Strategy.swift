class Strategy {

  struct Round {
    var bet: BetPlacement 
    var outcome: Bool

    init(bet: BetPlacement, outcome: Bool) {
        self.bet = bet
        self.outcome = outcome
    }
  }
  var rounds: [Round]
  var wallet: Int
  var startingWallet: Int
  var profit: Int
  var increaseOnWin: Bool

  init(rounds: [Round], wallet: Int = 500, profit: Int = 0, increaseOnWin: Bool) {
    self.rounds = rounds
    self.startingWallet = wallet
    self.wallet = wallet
    self.profit = profit
    self.increaseOnWin = increaseOnWin
  }

  func makeBet() {
    
  }

  func description() -> String {
    return ""
  }
}