class Strategy {

  var bets: [BetPlacement] = [] 
  var startingMoney: Int
  var profit: Int
  var increaseOnWin: Bool

  init(bets: [BetPlacement], increaseOnWin: Bool) {
    self.bets = bets
    self.startingMoney = 500
    self.profit = 0
    self.increaseOnWin = increaseOnWin
  }

  func makeBet() {
    print()
  }
}