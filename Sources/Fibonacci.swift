class Fibonacci: Strategy {

  let startingFibonacciNum1: Int = 2
  let startingFibonacciNum2: Int = 3

  override func description() -> String {
    return ("wallet: \(self.wallet), profit: \(self.profit), outcome: \(self.rounds.last!.outcome), amount bet: \(self.rounds.last!.bet.amountBet)")
  }
  override func makeBet() {

    var nextFibonacciNumber: Int

    var currentFibonacciNum1: Int
    var currentFibonacciNum2: Int

    if (self.rounds.isEmpty || self.rounds.last!.outcome == true) {
       nextFibonacciNumber = generateNextFibonacci(num1: startingFibonacciNum1, num2: startingFibonacciNum2)
    } else {
      if (self.rounds.count == 1 || (self.rounds.count > 1 && self.rounds[rounds.count - 2].outcome == true)) {  // make the second number 3, means win then loss
        currentFibonacciNum1 = 3
      } else { // means two losses in a row
        currentFibonacciNum1 = self.rounds[rounds.count - 2].bet.amountBet
      }
      currentFibonacciNum2 = self.rounds.last!.bet.amountBet
      nextFibonacciNumber = generateNextFibonacci(num1: currentFibonacciNum1, num2: currentFibonacciNum2)

    }
    self.rounds.append(Round(bet: BetPlacement(odds: (18 / 38), payout: (2), affectedPieces: redPieces, amountBet: nextFibonacciNumber), outcome: false))
    self.wallet = self.wallet - nextFibonacciNumber
  }

  func generateNextFibonacci(num1: Int, num2: Int) -> Int {
    return num1 + num2
  }

}