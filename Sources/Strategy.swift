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
