class Fibonacci: Strategy {

  override func description() -> String {
    return ("")
  }
  override func makeBet(bets: inout [Bet], wallet: inout Int) {

    // this strategy calls for betting on red every time
    var reds: [Bet] = betPlacements.filter{ $0.name == "reds" }

    if !bets.isEmpty { 
      for bet: Bet in bets {
        for affectedPiece: Piece in bet.affectedPieces {
          if (affectedPiece.color == prevRound.piece.color && affectedPiece.value == prevRound.piece.value) {
            reds[0].amountBet = generateNextFibonacci(prevNum: bet.amountBet)
            wallet = wallet - reds[0].amountBet
            bets = reds
          }
        }
      }
    }
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

}