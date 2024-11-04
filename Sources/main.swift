// The Swift Programming Language
// https://docs.swift.org/swift-book

struct Round {
  var roundNumber: Int
  var piece: Piece 

  init(roundNumber: Int = 0, piece: Piece) {
    self.roundNumber = roundNumber
    self.piece = piece
  }

  var description: String {
    return "Round Number: \(roundNumber), Color: \(piece.color) Value: \(piece.value)"
  }
}

struct Bet: CustomStringConvertible {

  var name: String
  var odds: Float
  var payout: Int
  var affectedPieces: [Piece] = []
  var roundNumber: Int 
  var amountBet: Int
  var force: Bool
  var outcome: String

  init(name: String, odds: Float, payout: Int, affectedPieces: [Piece], roundNumber: Int = 0, amountBet: Int = 0, force: Bool = false, outcome: String = "unknown") {
    self.name = name
    self.odds = odds
    self.payout = payout
    self.affectedPieces = affectedPieces
    self.roundNumber = roundNumber
    self.amountBet = amountBet
    self.force = force
    self.outcome = outcome
  }

  var description: String {
    var descriptionString: String = "{\n  Name: \(name),\n Odds: \(odds),\n  Payout: \(payout),\n  affectedPieces: {\n"
    for piece: Piece in affectedPieces {
      descriptionString = descriptionString + "    {Color: \(piece.color), Value: \(piece.value)},\n"
    }
    descriptionString = descriptionString.dropLast().dropLast() + "\n  Amount Bet: \(amountBet)  }\n}"
    return descriptionString
  }
}

struct BetSequence: CustomStringConvertible {
  var bets: [Bet]
  var consecutiveWins: Int

  init (bets: [Bet], consecutiveWins: Int) {
    self.bets = bets
    self.consecutiveWins = consecutiveWins
  }

  var description: String {
    var descriptionString: String = "{\n  bets: {\n"
    for bet: Bet in bets {
      descriptionString = "{\n  Name: \(bet.name),\n Odds: \(bet.odds),\n  Payout: \(bet.payout),\n  affectedPieces: {\n"
      descriptionString = descriptionString.dropLast().dropLast() + "\n  Amount Bet: \(bet.amountBet)  }\n}"
      return descriptionString
    }
    descriptionString = descriptionString.dropLast().dropLast() + "\n  consectiveWins: \(consecutiveWins)  }\n}"
    return descriptionString
  } 
}

struct Piece: CustomStringConvertible {
    var color: String
    var value: Int

    init(color: String, value: Int) {
        self.color = color
        self.value = value
    }

    var description: String {
      return "Color: \(color), Value: \(value)"
    }
}

let redNumbers: [Int] = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
let blackNumbers: [Int] = [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35]

var pieces: [Piece] = []
pieces.append(Piece(color: "other", value: -1))

var betPlacements: [Bet] = []

// make 0 = 37 and 00 = 38
for i: Int in 1...38 {

  var newPiece: Piece
  if (redNumbers.contains(i)) { // red piece
    newPiece = Piece(color: "red", value: i)
  } else if (blackNumbers.contains(i)) { // black piece
    newPiece = Piece(color: "black", value: i)
  } else { // green piece
    newPiece = Piece(color: "green", value: i)
  }
  pieces.append(newPiece) // append to piece array
}

// make each single bet 
for i: Int in 1...38 {
  betPlacements.append(Bet(name: "\(i)", odds: (1 / 38), payout: (36), affectedPieces: [pieces[i]]))
}

// single and double 0
// make double bets 
betPlacements.append(Bet(name: "0-00", odds: (2 / 38), payout: (18), affectedPieces: [pieces[37], pieces[38]])) // single and double 0
betPlacements.append(Bet(name: "1-2", odds: (2 / 38), payout: (18), affectedPieces: [pieces[1], pieces[2]]))
betPlacements.append(Bet(name: "2-3", odds: (2 / 38), payout: (18), affectedPieces: [pieces[2], pieces[3]]))  


// make triple bets
betPlacements.append(Bet(name: "0-1-2", odds: (3 / 38), payout: (12), affectedPieces: [pieces[37], pieces[1], pieces[2]])) // single 0, 1, 2
betPlacements.append(Bet(name: "0-00-2", odds: (3 / 38), payout: (12), affectedPieces: [pieces[37], pieces[38], pieces[2]])) // single 0, double 0, 2
betPlacements.append(Bet(name: "00-2-3", odds: (3 / 38), payout: (12), affectedPieces: [pieces[38], pieces[2], pieces[3]])) // double 0, 2, 3

// make five bets
betPlacements.append(Bet(name: "0-00-1-2-3", odds: (5 / 38), payout: (7), affectedPieces: [pieces[37], pieces[38], pieces[1], pieces[2], pieces[3]])) // double 0, 2, 3

var firstColumnPieces: [Piece] = []
var secondColumnPieces: [Piece] = []
var thirdColumnPieces: [Piece] = []

var redPieces: [Piece] = []
var blackPieces: [Piece] = []

var oddPieces: [Piece] = []
var evenPieces: [Piece] = []

for i: Int in 1...36 { // loop through rows

  let hasRightAndStreet: Bool = pieces.contains { $0.value == (i + 1) && i % 3 == 1 }
  let hasLeft: Bool = pieces.contains { $0.value == (i - 1) && i % 3 == 0 }
  let hasDown: Bool = pieces.contains { $0.value == (i + 3) && i < 34 }
  let hasCorner: Bool = pieces.contains {$0.value == (i + 4) && i % 3 > 0 }
  let hasLine: Bool = pieces.contains{ $0.value == (i + 4) && i % 3 == 1 && i < 34 }
  let hasSetOf12: Bool = pieces.contains{ $0.value == (i + 11) && i % 12 == 1 }
  let hasSetOf18: Bool = pieces.contains{ $0.value == (i + 17) && i % 18 == 1 }

  let hasFirstColumn: Bool = i % 3 == 0
  let hasSecondColumn: Bool = i % 3 == 1 
  let hasThirdColumn: Bool = i % 3 == 2

  let isRed: Bool = redNumbers.contains{ $0 == i }
  let isBlack: Bool = blackNumbers.contains{ $0 == i }

  let isOdd: Bool = i % 2 == 1
  let isEven: Bool = i % 2 == 0

  if (hasRightAndStreet) { // get right side and middle bets
    betPlacements.append(Bet(name: "\(i)-\(i + 1)", odds: (2 / 38), payout: (18), affectedPieces: [pieces[i], pieces[i + 1]]))
    betPlacements.append(Bet(name: "\(i)-\(i + 1)-\(i + 2)", odds: (3 / 38), payout: (12), affectedPieces: [pieces[i], pieces[i + 1], pieces[i + 2]]))
  } 
  if (hasLeft) { // get left side and middle bets
    betPlacements.append(Bet(name: "\(i)-\(i - 1)", odds: (2 / 38), payout: (18), affectedPieces: [pieces[i], pieces[i - 1]]))
  }
  if (hasDown) {
    betPlacements.append(Bet(name: "\(i)-\(i + 3)", odds: (2 / 38), payout: (18), affectedPieces: [pieces[i], pieces[i + 3]]))
  }
  if (hasCorner) {
    betPlacements.append(Bet(name: "\(i)-\(i + 1)-\(i + 3)-\(i + 4)", odds: (4 / 38), payout: (9), affectedPieces: [pieces[i], pieces[i + 1], pieces[i + 3], pieces[i + 4]]))
  }
  if (hasLine) {
    var currBetPlacements: [Piece] = []
    var nameString: String = "\(i)"
    for j: Int in i...(i + 5) {
      currBetPlacements.append(pieces[j])
      if (j != i) {
        nameString = nameString + "-\(j)"
      }
    }
    betPlacements.append(Bet(name: nameString, odds: (6 / 38), payout: (6), affectedPieces: currBetPlacements))
  }
  if (hasSetOf12) {
    var currBetPlacements: [Piece] = []
    var nameString: String = ""
    if (i < 6) {
      nameString = "lowerThird"
    } else if (i < 18) {
      nameString = "middleThird"
    } else {
      nameString = "upperThird"
    }
    for j: Int in i...(i + 11) {
      currBetPlacements.append(pieces[j])
    }
    betPlacements.append(Bet(name: nameString, odds: (12 / 38), payout: (3), affectedPieces: currBetPlacements))
  } 
  if (hasSetOf18) {
    var currBetPlacements: [Piece] = []
    var nameString: String = ""
    if (i < 15) {
      nameString = "lowerHalf"
    } else {
      nameString = "upperHalf"
    }
    for j: Int in i...(i + 17) {
      currBetPlacements.append(pieces[j])
    }
    betPlacements.append(Bet(name: nameString, odds: (18 / 38), payout: (2), affectedPieces: currBetPlacements))
  }
  if (isRed) {
    redPieces.append(pieces[i])
  } else if (isBlack) {
    blackPieces.append(pieces[i])
  }
  if (hasFirstColumn) {
    firstColumnPieces.append(pieces[i])
  } else if (hasSecondColumn) {
    secondColumnPieces.append(pieces[i])
  } else if (hasThirdColumn) {
    thirdColumnPieces.append(pieces[i])
  }
  if (isOdd) {
    oddPieces.append(pieces[i])
  } else if (isEven) {
    evenPieces.append(pieces[i])
  }
}

// add extra bets you had to count gradually
betPlacements.append(Bet(name: "firstColumn", odds: (12 / 38), payout: (3), affectedPieces: firstColumnPieces))
betPlacements.append(Bet(name: "secondColumn", odds: (12 / 38), payout: (3), affectedPieces: secondColumnPieces))
betPlacements.append(Bet(name: "thirdColumn", odds: (12 / 38), payout: (3), affectedPieces: thirdColumnPieces))

betPlacements.append(Bet(name: "reds", odds: (18 / 38), payout: (2), affectedPieces: redPieces))
betPlacements.append(Bet(name: "blacks", odds: (18 / 38), payout: (2), affectedPieces: blackPieces))

betPlacements.append(Bet(name: "odds", odds: (18 / 38), payout: (2), affectedPieces: oddPieces))
betPlacements.append(Bet(name: "evens", odds: (18 / 38), payout: (2), affectedPieces: evenPieces))


// TESTING BOARD 
let lengthsPerPayout: [Int : Int] = Dictionary(uniqueKeysWithValues: [(2, 18), (3, 12), (7, 5), (6, 6), (9, 4), (12, 3), (18, 2), (36, 1)])

// print("Checking for failed bets")
// for bet: Bet in betPlacements {
//   if (lengthsPerPayout[bet.payout] != bet.affectedPieces.count) {
//     print("Failed bets")
//     print(bet)
//   }
// }

// var fibonacci: Fibonacci = Fibonacci(rounds: [], increaseOnWin: false)
// var fibonacciSimulation: [Fibonacci] = []
// var rideTheWaveSimulation: [RideTheWave] = []
var gameRounds: [Round] = []

var roundNumber: Int = 1 
// var fibonacci: Fibonacci? = Fibonacci(gameNumber: 0, rounds: [], increaseOnWin: false)
// var rideTheWave: RideTheWave? = RideTheWave(gameNumber: 0, rounds: [], increaseOnWin: false)

var activePlayers: [Player] = []
var inactivePlayers: [Player] = []

func getPrevRound(piece: Piece) -> Round {

  // add the round
  var prevRound: Round
  if (gameRounds.count > 0) {
    prevRound = gameRounds.last!
  } else {
    prevRound = Round(roundNumber: -1, piece: pieces[0])
  }
  return(prevRound)
}
func getCurrRound(piece: Piece) -> Round {

  let currRound: Round = Round(roundNumber: roundNumber, piece: piece)
  return (currRound)
}

func getLeavingPlayers() -> [Player] {

  // loop through the active players looking for inactive players
  let leavingPlayers: [Player] = activePlayers.filter { $0.wallet == 0 } 
  for player: Player in leavingPlayers {
    if (player.wallet > 0) {
      player.profit = player.profit + player.wallet - player.startingWallet
      player.wallet = 0
    }
  }
  return (leavingPlayers)
}

while(roundNumber < 10000 + 1) {
  
  if (roundNumber % 1000 == 0) {
    print(roundNumber)
  }

  let spinNumber: Int = Int.random(in: 1...38)
  // var spinNumber: Int
  // if (roundNumber % 3 != 0) {
  //   spinNumber = 4
  // } else {
  //   spinNumber = 3
  // }
  var spinPiece: Piece?
  if pieces.contains(where: {
    if $0.value == spinNumber {
      spinPiece = $0 
      return true
    }
    return false
  }) {
    if let piece: Piece = spinPiece {
      
      let prevRound: Round = getPrevRound(piece: piece)
      let currRound: Round = getCurrRound(piece: piece)

      gameRounds.append(currRound)

      var leavingPlayers: [Player] = getLeavingPlayers()
      inactivePlayers.append(contentsOf: leavingPlayers)      
      activePlayers.removeAll { $0.wallet == 0 }   
  
      let playerEntryNumber: Int = Int.random(in: 1...5)
      if (playerEntryNumber > 4 && activePlayers.count < 9 && roundNumber < 9900) {
      // if (roundNumber == 1 || roundNumber == 1 || roundNumber == 1 || roundNumber == 1 || roundNumber == 1) {
        let randomStartingWallet: [Int] = [100, 200, 300, 400, 500, 750, 1000, 2000, 3000, 5000, 10000]
        // let randomStartingWallet: [Int] = [20]
        let randomMaxRounds: [Int] = [-1, 5, 10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 500]
        // let randomMaxRounds: [Int] = [10000]
        // let randomScaredWinnerSeed: Int = Int.random(in: 1...100)
        let randomSoreLoserSeed: Int = Int.random(in: 1...100)
        let ranodmImpatientLoserSeed: Int = Int.random(in: 1...100)
        let randomAddictSeed: Int = Int.random(in: 1...100)

        let startingWalletIndex: Int = Int.random(in: 0...randomStartingWallet.count - 1)
        let maxRoundsIndex: Int = Int.random(in: 0...randomMaxRounds.count - 1)
        
        // let scaredWinner: Bool = (randomScaredWinnerSeed < 6) ? false : false
        let soreLoser: Bool = (randomSoreLoserSeed < 11) ? true : false
        let impatientLoser: Bool = (ranodmImpatientLoserSeed < 4 && !soreLoser) ? true : false
        let addict: Bool = (randomAddictSeed < 21 && !soreLoser && !impatientLoser) ? true : false
        
        let reds: [Bet] = betPlacements.filter{ $0.name == "reds" }

        let lowerThird: [Bet] = betPlacements.filter{ $0.name == "lowerThird" }
        let middleThird: [Bet] = betPlacements.filter{ $0.name == "middleThird" }

        let bet6: [Bet] = betPlacements.filter{ $0.name == "16-17-18-19-20-21" }
        let bet5: [Bet] = betPlacements.filter{ $0.name == "0-00-1-2-3" }

        let bottomLeftCorner: [Bet] = betPlacements.filter{ $0.name == "1-2-4-5" }
        let bottomRightCorner: [Bet] = betPlacements.filter{ $0.name == "4-5-7-8" }
        let topLeftCorner: [Bet] = betPlacements.filter{ $0.name == "2-3-5-6" }
        let topRightCorner: [Bet] = betPlacements.filter{ $0.name == "5-6-8-9" }

        let bet1: [Bet] = betPlacements.filter{ $0.name == "11" }
        
        let fibonacciBetsList: [(bet: [Bet], amountBet: [Int])] = [
          (bet: reds, amountBet: [5, 13]),
          (bet: lowerThird, amountBet: [5, 13]),
          (bet: bet6, amountBet: [5, 13]),
          (bet: bet5, amountBet: [5, 13]),
          (bet: bottomLeftCorner, amountBet: [5, 13]),
          (bet: bet1, amountBet: [5, 13]),
          (bet: [lowerThird[0], middleThird[0]], amountBet: [5, 13]),  
          (bet: [topLeftCorner[0], topRightCorner[0], bottomLeftCorner[0], bottomRightCorner[0]], amountBet: [5, 13]) 
        ]

        var betSequencesFibonacci: [[BetSequence]] = []

        for (bet, amounts) in fibonacciBetsList {
          var sequences: [BetSequence] = []
          for amount: Int in amounts {
            var sequence: BetSequence = BetSequence(bets: bet, consecutiveWins: 0)
            for i in 0...bet.count - 1 {
              sequence.bets[i].amountBet = amount
            }
            sequences.append(sequence)
            betSequencesFibonacci.append(sequences)
            sequences = []
          }
        }

        let martingaleBetsList: [(bet: [Bet], amountBet: [Int])] = [
          (bet: reds, amountBet: [5, 25, 50, 100]),
          (bet: lowerThird, amountBet: [5, 25, 50, 100]),
          (bet: bet6, amountBet: [5, 25, 50, 100]),
          (bet: bet5, amountBet: [5, 25, 50, 100]),
          (bet: bottomLeftCorner, amountBet: [5, 25, 50, 100]),
          (bet: bet1, amountBet: [5, 25, 50, 100]),
          (bet: [lowerThird[0], middleThird[0]], amountBet: [5, 25, 50, 100]),  
          (bet: [topLeftCorner[0], topRightCorner[0], bottomLeftCorner[0], bottomRightCorner[0]], amountBet: [5, 25, 50, 100]) 
        ]

        var betSequencesMartingale: [[BetSequence]] = []

        for (bet, amounts) in martingaleBetsList {
          var sequences: [BetSequence] = []
          for amount: Int in amounts {
            var sequence: BetSequence = BetSequence(bets: bet, consecutiveWins: 0)
            for i in 0...bet.count - 1 {
              sequence.bets[i].amountBet = amount
            }
            sequences.append(sequence)
            betSequencesMartingale.append(sequences)
            sequences = []
          }
        }

        let minimumNetGainBetsList: [(bet: [Bet], amountBet: [Int])] = [
          (bet: reds, amountBet: [5]),
          (bet: lowerThird, amountBet: [5]),
          (bet: bet6, amountBet: [5]),
          (bet: bet5, amountBet: [5]),
          (bet: bottomLeftCorner, amountBet: [5]),
          (bet: bet1, amountBet: [5]),
          (bet: [lowerThird[0], middleThird[0]], amountBet: [5]),  
          (bet: [topLeftCorner[0], topRightCorner[0], bottomLeftCorner[0], bottomRightCorner[0]], amountBet: [5]) 
        ]

        var betSequencesMinimumNetGain: [[BetSequence]] = []

        for (bet, amounts) in minimumNetGainBetsList {
          var sequences: [BetSequence] = []
          for amount: Int in amounts {
            var sequence: BetSequence = BetSequence(bets: bet, consecutiveWins: 0)
            for i in 0...bet.count - 1 {
              sequence.bets[i].amountBet = amount
            }
            sequences.append(sequence)
            betSequencesMinimumNetGain.append(sequences)
            sequences = []
          }
        }

        // for betSequence: [BetSequence] in betSequencesMinimumNetGain {
        //   for sequence in betSequence {
        //     for bet in sequence.bets {
        //       print(" bet name: \(bet.name), bet amount: \(bet.amountBet) consecutive wins: \(sequence.consecutiveWins)")
        //     }
        //     print()
        //   }
        // }

        var fibonacciStrategies: [Strategy] = []
        for fibSequence: [BetSequence] in betSequencesFibonacci {
          fibonacciStrategies.append(Strategy(prevRound: prevRound, currRound: currRound, increaseOnWin: false, bettingStyle: "fibonacci", betSequence: fibSequence))
          fibonacciStrategies.append(Strategy(prevRound: prevRound, currRound: currRound, increaseOnWin: true, bettingStyle: "fibonacci", betSequence: fibSequence))
        }

        var martingaleStrategies: [Strategy] = []
        for martingaleSequence: [BetSequence] in betSequencesMartingale {
          martingaleStrategies.append(Strategy(prevRound: prevRound, currRound: currRound, increaseOnWin: false, bettingStyle: "martingale", betSequence: martingaleSequence))
          martingaleStrategies.append(Strategy(prevRound: prevRound, currRound: currRound, increaseOnWin: true, bettingStyle: "martingale", betSequence: martingaleSequence))
        }

        var minimumNetGainStrategies: [Strategy] = []
        for minimumNetGainSequence: [BetSequence] in betSequencesMinimumNetGain {
          minimumNetGainStrategies.append(Strategy(prevRound: prevRound, currRound: currRound, increaseOnWin: false, bettingStyle: "martingale", betSequence: minimumNetGainSequence))
          minimumNetGainStrategies.append(Strategy(prevRound: prevRound, currRound: currRound, increaseOnWin: true, bettingStyle: "martingale", betSequence: minimumNetGainSequence))
        }

        let strategies: [[Strategy]] = [fibonacciStrategies, martingaleStrategies, minimumNetGainStrategies]
        let startingStrategyType: Int = Int.random(in: 0...strategies.count - 1)

        let startingStrategy: Int = Int.random(in: 0...strategies[startingStrategyType].count - 1) 

        // "strategy name: \(strategies[startingStrategyType][startingStrategy].bettingStyle)")
        // for sequence in strategies[startingStrategyType][startingStrategy].betSequence {
        //   for bet in sequence.bets {
        //     print("bet name \(bet.name) bet amount \(bet.amountBet)")
        //   }
        //   print()
        // }
        // print("end strategy")

        activePlayers.append(Player(id: (activePlayers.count + inactivePlayers.count), startingWallet: randomStartingWallet[startingWalletIndex], strategy: strategies[startingStrategyType][startingStrategy], maxRounds: randomMaxRounds[maxRoundsIndex], /*scaredWinner: scaredWinner,*/ soreLoser: soreLoser, impatientLoser: impatientLoser, addict: addict, rounds: [], playedBets: [], wallet: randomStartingWallet[startingWalletIndex], profit: 0))

        // print("roundNumber \(roundNumber) player id: \(activePlayers.last!.id) is joining")
      }

      // for player: Player in activePlayers {
      //   print("round number: \(roundNumber), player id: \(player.id), player active wallet: \(player.wallet)")
      // }

      for player: Player in activePlayers {
        var forcedBetAmount: Int = -1
        // print("roundNumber \(roundNumber) player id: \(player.id) is playing, player wallet: \(player.wallet)")
        player.strategy.prevRound = prevRound
        player.strategy.currRound = currRound
        if ((player.maxRounds == player.rounds.count) || ((player.soreLoser) && (player.determineConsecutiveOutcome(outcome: "lost") > 3))) {
          // print("roundNumber \(roundNumber) player id: \(player.id) is leaving")
          player.profit = player.profit + player.wallet - player.startingWallet
          player.wallet = 0
          forcedBetAmount = -5
          player.willLeave = true
        }
        // print("maxrounds avoided")
        if (player.impatientLoser && player.determineConsecutiveOutcome(outcome: "lost") >= 3) {
          // go all in
          // print("TIME")
          forcedBetAmount = player.wallet
        }
        // print("imp loser avoided")
        var canPlayerBet: Bool = player.makeBet(roundNumber: roundNumber, forcedBetAmount: forcedBetAmount)
        // print("roundNumber \(roundNumber) player id: \(player.id) is playing, player wallet: \(player.wallet), can player bet? \(canPlayerBet), forced bet amount: \(forcedBetAmount)")
        if (canPlayerBet == false) {
          if (player.addict && player.profit > 0 && player.profit + player.wallet < player.startingWallet) {
            // print("player is an addict, profit was \(player.profit) but started with \(player.startingWallet)")
            player.wallet = player.wallet + player.profit
            player.profit = 0
            canPlayerBet = player.makeBet(roundNumber: roundNumber, forcedBetAmount: forcedBetAmount)
          }
          if(canPlayerBet == false && player.willLeave == false) {
            player.profit = player.profit + player.wallet - player.startingWallet
            player.wallet = 0
            player.willLeave = true
          }
        }
      }

      // for player: Player in activePlayers {
        // print("round number: \(roundNumber), player id: \(player.id), player active wallet: \(player.wallet)")
      // }

      leavingPlayers = getLeavingPlayers()
      inactivePlayers.append(contentsOf: leavingPlayers)      
      activePlayers.removeAll { $0.wallet == 0 }  

      for player: Player in activePlayers {
        // print("roundNumber \(roundNumber) player id: \(player.id) is getting there bet checked")
        if (player.playedBets.count > 0 && player.playedBets.last!.roundNumber == roundNumber) {
          // print("roundNumber \(roundNumber) player id: \(player.id) made a bet, bet is \(player.playedBets.last!.description)")
          player.rounds.append(currRound)
        }
        for i: Int in stride(from: player.playedBets.count - 1, through: 0, by: -1) {
          // print("Bet Round Num: \(player.playedBets[i].roundNumber), roundNumber: \(roundNumber)")
          if (player.playedBets[i].roundNumber == roundNumber) {
            // print("Round Num: \(player.playedBets[i].roundNumber), Name of Bet: \(player.playedBets[i].name), Amount Bet: \(player.playedBets[i].amountBet)")
            if (player.strategy.wonBet(bet: player.playedBets[i], prev: false) == true) {
              // print("recieving payout, old prfit: \(player.profit), ", terminator: "")
              // print("dsvdv roundNumber \(roundNumber) player id: \(player.id) won")
              player.profit = player.profit + (player.playedBets[i].amountBet * (player.playedBets[i].payout - 1))
              player.playedBets[i].outcome = "won" 
            } else {
              // print("roundNumber \(roundNumber) player id: \(player.id) lost")
              player.wallet = player.wallet - player.playedBets[i].amountBet
              // print("roundNumber \(roundNumber) player wallet left: \(player.wallet) after losing")
              if (player.impatientLoser && player.wallet == 0 && player.playedBets.last!.force == true) {
                player.profit = player.profit - player.startingWallet
              }
              // print("old player.playedBets[i] outcome \(player.playedBets[i].outcome)")
              player.playedBets[i].outcome = "lost"
              // print("new player.playedBets[i] outcome \(player.playedBets[i].outcome)")
            }
            // print("Round Num: \(player.playedBets[i].roundNumber), Name of Bet: \(player.playedBets[i].name), Amount Bet: \(player.playedBets[i].amountBet) bet outcome \(player.playedBets[i].outcome) player profit \(player.profit)")
          } else {
            break
          }
        }
      }
      // if (activePlayers.count > 0) {
      //   print("RoundNumber \(roundNumber) Menu: ")
      //   print("Spun Piece for the round: \(piece.description)")
      //   for player: Player in activePlayers {
      //     print("Round Num: \(roundNumber), Player Id \(player.id), Starting Wallet: \(player.startingWallet), Wallet: \(player.wallet), Profit: \(player.profit), player max rounds: \(player.maxRounds), Player Strategy: \(player.strategy)")
      //     for i: Int in stride(from: player.playedBets.count - 1, through: (player.playedBets.count > 1) ? player.playedBets.count - 2 : 0, by: -1) {
      //       let bet: Bet = player.playedBets[i]
      //       print("Round Num: \(bet.roundNumber), Amount Bet: \(bet.amountBet)")
      //     }
      //     print()
      //   }
      // }
//      for player in activePlayers {
//        for bet in player.playedBets {
//          print("player id: \(player.id) player wallet: \(player.wallet) player profit: \(player.profit) bet outcome: \(bet.outcome) bet amount: \(bet.amountBet) bet outcome: \(bet.outcome) bet roundNumber \(bet.roundNumber) bet force: \(bet.force) current round: \(roundNumber) piece color \(piece.color) piece value: \(piece.value)")
//        }
//      }
      roundNumber = roundNumber + 1
    }
  }
}

for player: Player in activePlayers {
  if (player.wallet > 0) {
    player.profit = player.profit + player.wallet - player.startingWallet
    player.wallet = 0
  }
}
inactivePlayers.append(contentsOf: activePlayers)      
activePlayers.removeAll()

// print("-------- start round number check ---------")
// var fsum: Int = 0
// for player: Player in inactivePlayers {
//   print("player starting money \(player.startingWallet)")
//   for bet: Bet in player.playedBets {
//     if (bet.outcome == "won") {
//       fsum = fsum + (bet.amountBet * (bet.payout - 1))
//       print("won \(bet.amountBet * (bet.payout - 1)) dollars")
//     } else {
//       fsum = fsum - bet.amountBet
//       print("lost \(bet.amountBet) dollars")
//     }
//     print("round number \(bet.roundNumber) bet name \(bet.name) bet amount \(bet.amountBet) bet outcome \(bet.outcome) current fsum \(fsum)")
//   }
//   print("FSUM: \(fsum)")
// }
// print("-------- end round number check ---------")
// print(activePlayers.count)
// for player: Player in activePlayers {
//   print("Name: \(player.name), Wallet: \(player.wallet), Profit: \(player.profit)")
// }
// fibonacciSimulation.append(fibonacci!)
// fibonacci = nil

// rideTheWaveSimulation.append(rideTheWave!)
// rideTheWave = nil

// for f: Fibonacci in fibonacciSimulation {
//   print(f.description())
// }

let csvWriter: CSVWriter = CSVWriter()

let boardHeaders: [String] = ["value", "color"]
let boardCsv: String = csvWriter.createCSV(from: pieces, using: boardHeaders) { piece in
  return ["\(piece.value)", piece.color]
}
csvWriter.writeCSV(to: "board.csv", content: boardCsv)

let betHeaders: [String] = ["name", "odds", "payout"]
let betCsv: String = csvWriter.createCSV(from: betPlacements, using: betHeaders) { betPlacement in 
  return [betPlacement.name, "\(betPlacement.odds)", "\(betPlacement.payout)"]
}
csvWriter.writeCSV(to: "bet.csv", content: betCsv)

let gameHeaders: [String] = ["value", "color"]
let gameCsv: String = csvWriter.createCSV(from: gameRounds, using: gameHeaders) { game in
  return ["\(game.roundNumber)", "\(game.piece.value)", game.piece.color]
}
csvWriter.writeCSV(to: "rounds.csv", content: gameCsv)


let playerHeaders: [String] = ["id", "starting wallet", "strategy", "increase on win", "max rounds", "starting round", "ending round", "starting bet", "starting bet amount", "average bet", "sore loser", "impatient loser", "addict", "profit"]
let peopleCsv: String = csvWriter.createCSV(from: inactivePlayers, using: playerHeaders) { player in
  return ["\(player.id)", "\(player.startingWallet)", "\(player.strategy.bettingStyle)", "\(player.strategy.increaseOnWin)", "\(player.maxRounds)", "\(player.rounds[0].roundNumber)", "\(player.rounds.last!.roundNumber)", "\(player.getDefaultStartingBetNames())", "\(player.getDefaultStartingBetSize())", "\(player.getAverageBet())", "\(player.soreLoser)", "\(player.impatientLoser)", "\(player.addict)", "\(player.profit)"]
}
csvWriter.writeCSV(to: "people.csv", content: peopleCsv)

// let rideTheWaveHeaders: [String] = ["game", "rounds", "profit"]
// let rideTheWaveCsv: String = csvWriter.createCSV(from: rideTheWaveSimulation, using: rideTheWaveHeaders) { rideTheWave in
//   return ["\(rideTheWave.gameNumber)", "\(rideTheWave.rounds.count)", "\(rideTheWave.profit - rideTheWave.startingWallet)"]
// }
// csvWriter.writeCSV(to: "rideTheWave.csv", content: rideTheWaveCsv)
