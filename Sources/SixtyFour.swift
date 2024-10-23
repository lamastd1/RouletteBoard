class SixtyFour: Strategy {

  override func description() -> String {
    return ("")
  }
  override func makeBet(bets: inout [Bet], wallet: Int, roundNumber: Int, forcedBetAmount: Int) -> Bool {

    print("From sixty four roundNumber: \(roundNumber)")

    // this strategy calls for betting on red every time and creates a copy of the default red bet
    var lowerThird: [Bet] = betPlacements.filter{ $0.name == "lowerThird" }
    var middleThird: [Bet] = betPlacements.filter{ $0.name == "middleThird" }

    if (forcedBetAmount == -5) {
      return false
    }
    if (forcedBetAmount != -1) {
      lowerThird[0].amountBet = forcedBetAmount
      lowerThird[0].roundNumber = roundNumber
      lowerThird[0].force = true
      bets.append(lowerThird[0])

      middleThird[0].amountBet = forcedBetAmount
      middleThird[0].roundNumber = roundNumber
      middleThird[0].force = true
      bets.append(middleThird[0])
      return true
    }
    lowerThird[0].amountBet = 5
    lowerThird[0].roundNumber = roundNumber

    middleThird[0].amountBet = 5
    middleThird[0].roundNumber = roundNumber
    
    if (lowerThird[0].amountBet + lowerThird[0].amountBet < wallet) {
      bets.append(lowerThird[0])
      bets.append(middleThird[0])
      return true
    } else {
      return false
    }
  }
}