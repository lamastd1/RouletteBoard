// The Swift Programming Language
// https://docs.swift.org/swift-book

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

struct BetPlacement: CustomStringConvertible {

  var odds: Float
  var payout: Int
  var affectedPieces: [Piece] = []
  var amountBet: Int

  init(odds: Float, payout: Int, affectedPieces: [Piece], amountBet: Int = 0) {
      self.odds = odds
      self.payout = payout
      self.affectedPieces = affectedPieces
      self.amountBet = amountBet
  }

  var description: String {
    var descriptionString: String = "{\n  Odds: \(odds),\n  Payout: \(payout),\n  affectedPieces: {\n"
    for piece: Piece in affectedPieces {
      descriptionString = descriptionString + "    {Color: \(piece.color), Value: \(piece.value)},\n"
    }
    descriptionString = descriptionString.dropLast().dropLast() + "\n  Amount Bet: \(amountBet)  }\n}"
    return descriptionString
  }
}

let redNumbers: [Int] = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
let blackNumbers: [Int] = [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35]

var pieces: [Piece] = []
pieces.append(Piece(color: "other", value: -1))

var betPlacements: [BetPlacement] = []

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
  betPlacements.append(BetPlacement(odds: (1 / 38), payout: (36), affectedPieces: [pieces[i]]))
}

// single and double 0
// make double bets 
betPlacements.append(BetPlacement(odds: (2 / 38), payout: (18), affectedPieces: [pieces[37], pieces[38]])) // single and double 0
betPlacements.append(BetPlacement(odds: (2 / 38), payout: (18), affectedPieces: [pieces[1], pieces[2]]))
betPlacements.append(BetPlacement(odds: (2 / 38), payout: (18), affectedPieces: [pieces[2], pieces[3]]))  


// make triple bets
betPlacements.append(BetPlacement(odds: (3 / 38), payout: (12), affectedPieces: [pieces[37], pieces[1], pieces[2]])) // single 0, 1, 2
betPlacements.append(BetPlacement(odds: (3 / 38), payout: (12), affectedPieces: [pieces[37], pieces[38], pieces[2]])) // single 0, double 0, 2
betPlacements.append(BetPlacement(odds: (3 / 38), payout: (12), affectedPieces: [pieces[38], pieces[2], pieces[3]])) // double 0, 2, 3

// make five bets
betPlacements.append(BetPlacement(odds: (5 / 38), payout: (7), affectedPieces: [pieces[37], pieces[38], pieces[1], pieces[2], pieces[3]])) // double 0, 2, 3

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
    betPlacements.append(BetPlacement(odds: (2 / 38), payout: (18), affectedPieces: [pieces[i], pieces[i + 1]]))
    betPlacements.append(BetPlacement(odds: (3 / 38), payout: (12), affectedPieces: [pieces[i], pieces[i + 1], pieces[i + 2]]))
  } 
  if (hasLeft) { // get left side and middle bets
    betPlacements.append(BetPlacement(odds: (2 / 38), payout: (18), affectedPieces: [pieces[i], pieces[i - 1]]))
  }
  if (hasDown) {
    betPlacements.append(BetPlacement(odds: (2 / 38), payout: (18), affectedPieces: [pieces[i], pieces[i + 3]]))
  }
  if (hasCorner) {
    betPlacements.append(BetPlacement(odds: (4 / 38), payout: (9), affectedPieces: [pieces[i], pieces[i + 1], pieces[i + 3], pieces[i + 4]]))
  }
  if (hasLine) {
    var currBetPlacements: [Piece] = []
    for j: Int in i...(i + 5) {
      currBetPlacements.append(pieces[j])
    }
    betPlacements.append(BetPlacement(odds: (6 / 38), payout: (6), affectedPieces: currBetPlacements))
  }
  if (hasSetOf12) {
    var currBetPlacements: [Piece] = []
    for j: Int in i...(i + 11) {
      currBetPlacements.append(pieces[j])
    }
    betPlacements.append(BetPlacement(odds: (12 / 38), payout: (3), affectedPieces: currBetPlacements))
  } 
  if (hasSetOf18) {
    var currBetPlacements: [Piece] = []
    for j: Int in i...(i + 17) {
      currBetPlacements.append(pieces[j])
    }
    betPlacements.append(BetPlacement(odds: (18 / 38), payout: (2), affectedPieces: currBetPlacements))
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
betPlacements.append(BetPlacement(odds: (12 / 38), payout: (3), affectedPieces: firstColumnPieces))
betPlacements.append(BetPlacement(odds: (12 / 38), payout: (3), affectedPieces: secondColumnPieces))
betPlacements.append(BetPlacement(odds: (12 / 38), payout: (3), affectedPieces: thirdColumnPieces))

betPlacements.append(BetPlacement(odds: (18 / 38), payout: (2), affectedPieces: redPieces))
betPlacements.append(BetPlacement(odds: (18 / 38), payout: (2), affectedPieces: blackPieces))

betPlacements.append(BetPlacement(odds: (18 / 38), payout: (2), affectedPieces: oddPieces))
betPlacements.append(BetPlacement(odds: (18 / 38), payout: (2), affectedPieces: evenPieces))


// TESTING BOARD 
let lengthsPerPayout: [Int : Int] = Dictionary(uniqueKeysWithValues: [(2, 18), (3, 12), (7, 5), (6, 6), (9, 4), (12, 3), (18, 2), (36, 1)])

// print("Checking for failed bets")
// for bet: BetPlacement in betPlacements {
//   if (lengthsPerPayout[bet.payout] != bet.affectedPieces.count) {
//     print("Failed bets")
//     print(bet)
//   }
// }

var fibonacci: Fibonacci = Fibonacci(rounds: [], increaseOnWin: false)
var fibonacciSimulation: [Fibonacci] = []

for _ in 1...100 {

  fibonacci.makeBet()

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
      if (fibonacci.rounds.count > 0) {
        if ( fibonacci.rounds.last!.bet.affectedPieces.contains(where: { $0.value == piece.value && $0.color == piece.color })) {
          fibonacci.profit = fibonacci.profit + ( fibonacci.rounds.last!.bet.amountBet * ( fibonacci.rounds.last!.bet.payout - 1))
          fibonacci.wallet = fibonacci.wallet +  fibonacci.rounds.last!.bet.amountBet
          fibonacci.rounds[fibonacci.rounds.count - 1].outcome = true
        } else { // check if the game is over
          if (fibonacci.wallet <= 0) {
            fibonacciSimulation.append(fibonacci)
            print(fibonacci.description())
            break;
          }
        }
      } 
    }
  }
  fibonacciSimulation.append(fibonacci)
  print(fibonacci.description())
}

let csvWriter: CSVWriter = CSVWriter()

let boardHeaders: [String] = ["value", "color"]
let boardCsv: String = csvWriter.createCSV(from: pieces, using: boardHeaders) { piece in
  return ["\(piece.value)", piece.color]
}
csvWriter.writeCSV(to: "board.csv", content: boardCsv)

let fibonacciHeaders: [String] = ["rounds", "profit", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "0", "00"]