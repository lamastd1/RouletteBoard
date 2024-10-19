class Strategy {

  var prevRound: Round
  var currRound: Round
  var increaseOnWin: Bool

  init(prevRound: Round, currRound: Round, increaseOnWin: Bool) {
    self.prevRound = prevRound
    self.currRound = currRound
    self.increaseOnWin = increaseOnWin
  }

  func makeBet(bets: inout [Bet], wallet: inout Int) {
    
  }

  func description() -> String {
    return ""
  }
}