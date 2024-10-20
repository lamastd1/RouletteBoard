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
  var amountBet: Int

  init(name: String, odds: Float, payout: Int, affectedPieces: [Piece], amountBet: Int = 0) {
    self.name = name
    self.odds = odds
    self.payout = payout
    self.affectedPieces = affectedPieces
    self.amountBet = amountBet
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
// var martingaleSimulation: [Martingale] = []
var gameRounds: [Round] = []

var roundNumber: Int = 1 
// var fibonacci: Fibonacci? = Fibonacci(gameNumber: 0, rounds: [], increaseOnWin: false)
// var martingale: Martingale? = Martingale(gameNumber: 0, rounds: [], increaseOnWin: false)

var players: [Player] = []

while(roundNumber < 500 + 1) {

  let spinNumber: Int = Int.random(in: 1...38)
  var spinPiece: Piece?
  if pieces.contains(where: {
    if $0.value == spinNumber {
      spinPiece = $0 
      return true
    }
    return false
  }) {
    if let piece: Piece = spinPiece {

      // add the round
      var prevRound: Round
      if (gameRounds.count > 0) {
        prevRound = gameRounds.last!
      } else {
        prevRound = Round(roundNumber: -1, piece: pieces[0])
      }
      let currRound: Round = Round(roundNumber: roundNumber, piece: piece)
      gameRounds.append(currRound)

      for player: Player in players {
        player.strategy.prevRound = prevRound
        player.strategy.currRound = currRound
        var sum: Int = 0
        for bet: Bet in player.bets {
          sum = sum + bet.amountBet
        }
        if (player.wallet - sum > sum) {
          player.makeBet()
        } else {
          print("player wallet \(player.wallet), sum: \(sum)")
          player.bets = []
        }
      }

      let playerEntryNumber: Int = Int.random(in: 1...100)
      // if (playerEntryNumber == 11 && roundNumber < 400) {
      if (roundNumber == 3) {
        let randomNames: [String] = ["Rick", "Carl", "Lauri", "Herschel", "Michonne", "Daryl", "Glenn", "Maggie", "Negan", "Carol", "Beth", "Judith", "Abraham", "Eugene", "Sasha", "Rosita", "Tara", "Merle", "Shane", "Andrea", "Dwight", "Gabriel", "Henry", "Jesus", "Alpha", "Beta", "Joe", "T-Dog"]
        let randomStartingWallet: [Int] = [25, 50, 75, 100, 200, 300, 400, 500, 1000, 2000, 3000, 5000, 10000]
        let randomMaxRounds: [Int] = [-1, 5, 10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 1000]

        let nameIndex: Int = Int.random(in: 0...randomNames.count - 1)
        let startingWalletIndex: Int = Int.random(in: 0...randomStartingWallet.count - 1)
        let maxRoundsIndex: Int = Int.random(in: 0...randomMaxRounds.count - 1)
        
        let fibonacci: Fibonacci = Fibonacci(prevRound: prevRound, currRound: currRound, increaseOnWin: false)

        players.append(Player(name: randomNames[nameIndex], startingWallet: randomStartingWallet[startingWalletIndex], maxRounds: randomMaxRounds[maxRoundsIndex], strategy: fibonacci, rounds: [], bets: [], wallet: randomStartingWallet[startingWalletIndex], profit: 0))
      }
      for player: Player in players {
        if (player.wallet > 4 && player.bets.count > 0) {
          print("Round Num: \(roundNumber), description: \(piece.description)")
          for bet: Bet in player.bets {
            print("Round Num: \(roundNumber), Amount Bet: \(player.bets[0].amountBet)")
            if (player.strategy.wonBet(bet: bet, prev: false) == true) {
              player.profit = player.profit + (bet.amountBet * (bet.payout - 1))
              player.strategy.prevRound = currRound
            } else {
              player.wallet = player.wallet - bet.amountBet
            }
          }
          for player: Player in players {
            print("Round Num: \(roundNumber), Name: \(player.name), Starting Wallet: \(player.startingWallet), Wallet: \(player.wallet), Profit: \(player.profit)")
          }
          print()
        }
      }
      if (roundNumber == 3 || roundNumber == 4 || roundNumber == 500) {
      }
      roundNumber = roundNumber + 1
    }
  }
}
// print(players.count)
// for player: Player in players {
//   print("Name: \(player.name), Wallet: \(player.wallet), Profit: \(player.profit)")
// }
// fibonacciSimulation.append(fibonacci!)
// fibonacci = nil

// martingaleSimulation.append(martingale!)
// martingale = nil

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


// let fibonacciHeaders: [String] = ["game", "rounds", "profit"]
// let fibonacciCsv: String = csvWriter.createCSV(from: fibonacciSimulation, using: fibonacciHeaders) { fibonacci in
//   return ["\(fibonacci.gameNumber)", "\(fibonacci.rounds.count)", "\(fibonacci.profit - fibonacci.startingWallet)"]
// }
// csvWriter.writeCSV(to: "fibonacci.csv", content: fibonacciCsv)

// let martingaleHeaders: [String] = ["game", "rounds", "profit"]
// let martingaleCsv: String = csvWriter.createCSV(from: martingaleSimulation, using: martingaleHeaders) { martingale in
//   return ["\(martingale.gameNumber)", "\(martingale.rounds.count)", "\(martingale.profit - martingale.startingWallet)"]
// }
// csvWriter.writeCSV(to: "martingale.csv", content: martingaleCsv)

