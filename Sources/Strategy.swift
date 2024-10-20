class Strategy {

  var prevRound: Round
  var currRound: Round
  var increaseOnWin: Bool

  init(prevRound: Round, currRound: Round, increaseOnWin: Bool) {
    self.prevRound = prevRound
    self.currRound = currRound
    self.increaseOnWin = increaseOnWin
  }

  func makeBet(bets: inout [Bet], wallet: Int, roundNumber: Int, forcedBetAmount: Int) -> Bool {
    return true
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
}