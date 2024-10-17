class Martingale: Strategy {

  let startingMartingale: Int = 5

  override func description() -> String {
    return ("round number: \(self.rounds.last!.roundNumber), wallet: \(self.wallet), profit: \(self.profit), outcome: \(self.rounds.last!.outcome), amount bet: \(self.rounds.last!.bet.amountBet)")
  }
  override func makeBet(roundNumber: Int) {

    var nextMartingaleNumber: Int

    if (self.rounds.isEmpty) {
       nextMartingaleNumber = generateNextMartingale(num1: startingMartingale)
    } else if (self.rounds.last!.outcome == true) {
      nextMartingaleNumber = generateNextMartingale(num1: self.rounds.last!.bet.amountBet)
    } else {
      nextMartingaleNumber = 5
    }
    
    let usableBets: [BetPlacement] = betPlacements.filter { $0.name == "reds" }

    if !usableBets.isEmpty {
      for var bet: BetPlacement in usableBets {
        bet.amountBet = nextMartingaleNumber
        self.rounds.append(Round(roundNumber: roundNumber, bet: bet, outcome: false))
        self.wallet = self.wallet - nextMartingaleNumber
      }
    }
  }

  func generateNextMartingale(num1: Int) -> Int {
    return num1 * 2
  }

}