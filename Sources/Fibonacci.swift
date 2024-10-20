class Fibonacci: Strategy {

  override func description() -> String {
    return ("")
  }
  override func makeBet(bets: inout [Bet], wallet: inout Int) {

    // this strategy calls for betting on red every time and creates a copy of the default red bet
    var reds: [Bet] = betPlacements.filter{ $0.name == "reds" }

    if !bets.isEmpty { 
      for bet: Bet in bets {
        var prevOutcomeWin: Bool = false
        if (wonBet(bet: bet, prev: true) == true) {
          reds[0].amountBet = 5
          bets = reds
          prevOutcomeWin = true
        }
        if (prevOutcomeWin == false && bets[0].amountBet != 0) {
          reds[0].amountBet = generateNextFibonacci(prevNum: bets[0].amountBet)
          bets = reds
        }
      }
    } else {
      reds[0].amountBet = 5
      bets = reds
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