class Martingale: Strategy {

  override func description() -> String {
    return ("")
  }
  override func makeBet(bets: inout [Bet], wallet: Int, roundNumber: Int, forcedBetAmount: Int) -> Bool {

    // this strategy calls for betting on red every time and creates a copy of the default red bet
    var reds: [Bet] = betPlacements.filter{ $0.name == "reds" }

    if (forcedBetAmount == -5) {
      return false
    }
    if (forcedBetAmount != -1) {
      reds[0].amountBet = forcedBetAmount
      reds[0].roundNumber = roundNumber
      reds[0].force = true
      bets.append(reds[0])
      return true
    }

    if !bets.isEmpty { 
      for bet: Bet in bets {
        if (bet.roundNumber == roundNumber - 1) {
          var prevOutcomeWin: Bool = true
          if (bet.force == true) {
            print("bet force is true")
            prevOutcomeWin = false
          }
          if (wonBet(bet: bet, prev: true) == true) {
            reds[0].amountBet = generateNextMartingale(num1: bet.amountBet)
            if (reds[0].amountBet > wallet) {
              reds[0].amountBet = wallet
            }
            reds[0].roundNumber = roundNumber
            prevOutcomeWin = false
          }
          if (prevOutcomeWin == true) {
            reds[0].amountBet = 5
            reds[0].roundNumber = roundNumber
          }
        }
      }
    } else {
      reds[0].amountBet = 5
      reds[0].roundNumber = roundNumber
    }
    if (reds[0].amountBet < wallet) {
      bets.append(reds[0])
      return true
    } else {
      return false
    }
  }

  func generateNextMartingale(num1: Int) -> Int {
    print(num1 * 2)
    return num1 * 2
  }
}
