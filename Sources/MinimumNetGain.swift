// class MinimumNetGain: Strategy {

//   override func description() -> String {
//     return ("")
//   }
//   override func makeBet(bets: inout [Bet], wallet: Int, roundNumber: Int, forcedBetAmount: Int) -> Bool {

//     // this strategy calls for betting on red every time and creates a copy of the default red bet
//     var reds: [Bet] = betPlacements.filter{ $0.name == "reds" }

//     if (forcedBetAmount == -5) {
//       return false
//     }
//     if (forcedBetAmount != -1) {
//       reds[0].amountBet = forcedBetAmount
//       reds[0].roundNumber = roundNumber
//       reds[0].force = true
//       bets.append(reds[0])
//       return true
//     }

//     if !bets.isEmpty { 
//       for bet: Bet in bets {
//         if (bet.roundNumber == roundNumber - 1) {
//           var prevOutcomeWin: Bool = false
//           if (bet.force == true) {
//             print("bet force is true")
//             prevOutcomeWin = true
//           }
//           if (wonBet(bet: bet, prev: true) == true) {
//             print("won last time, getting the minimum")
//             reds[0].amountBet = 5
//             reds[0].roundNumber = roundNumber
//             prevOutcomeWin = true
//           }
//           if (prevOutcomeWin == false && bets[0].amountBet != 0) {
//             print("lost last time, escalating bet")
//             reds[0].amountBet = generateNextMinimumNetGain(prevNum: bet.amountBet)
//             reds[0].roundNumber = roundNumber
//           }
//         }
//       }
//     } else {
//       print("starting minimum bet")
//       reds[0].amountBet = 5
//       reds[0].roundNumber = roundNumber
//     }
//     if (reds[0].amountBet < wallet) {
//       bets.append(reds[0])
//       return true
//     } else {
//       return false
//     }
//   }

//   func generateNextMinimumNetGain(prevNum: Int) -> Int {
//     if prevNum == 5 {
//         return 6
//     } else {
//         return prevNum * 2
//     }
//   }
// }