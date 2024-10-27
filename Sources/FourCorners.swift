// class FourCorners: Strategy {

//   override func description() -> String {
//     return ("")
//   }
//   override func makeBet(bets: inout [Bet], wallet: Int, roundNumber: Int, forcedBetAmount: Int) -> Bool {

//     print("From sixty four roundNumber: \(roundNumber)")

//     // this strategy calls for betting on red every time and creates a copy of the default red bet
//     var corner1: [Bet] = betPlacements.filter{ $0.name == "1-2-4-5" }
//     var corner2: [Bet] = betPlacements.filter{ $0.name == "2-3-5-6" }
//     var corner3: [Bet] = betPlacements.filter{ $0.name == "4-5-7-8" }
//     var corner4: [Bet] = betPlacements.filter{ $0.name == "5-6-8-9" }

//     if (forcedBetAmount == -5) {
//       return false
//     }
//     if (forcedBetAmount != -1) {
//       corner1[0].amountBet = forcedBetAmount
//       corner1[0].roundNumber = roundNumber
//       corner1[0].force = true
//       bets.append(corner1[0])

//       corner2[0].amountBet = forcedBetAmount
//       corner2[0].roundNumber = roundNumber
//       corner2[0].force = true
//       bets.append(corner2[0])

//       corner3[0].amountBet = forcedBetAmount
//       corner3[0].roundNumber = roundNumber
//       corner3[0].force = true
//       bets.append(corner3[0])

//       corner4[0].amountBet = forcedBetAmount
//       corner4[0].roundNumber = roundNumber
//       corner4[0].force = true
//       bets.append(corner4[0])
//       return true
//     }
//     corner1[0].amountBet = 5
//     corner1[0].roundNumber = roundNumber

//     corner2[0].amountBet = 5
//     corner2[0].roundNumber = roundNumber

//     corner3[0].amountBet = 5
//     corner3[0].roundNumber = roundNumber

//     corner4[0].amountBet = 5
//     corner4[0].roundNumber = roundNumber
    
//     if (corner1[0].amountBet + corner2[0].amountBet + corner3[0].amountBet + corner4[0].amountBet < wallet) {
//       bets.append(corner1[0])
//       bets.append(corner2[0])
//       return true
//     } else {
//       return false
//     }
//   }
// }