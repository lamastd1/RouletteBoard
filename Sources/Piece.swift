class Piece {
    var color: String
    var number: Int

    init(color: String, number: Int) {
        self.color = color
        self.number = number
    }

    func description() -> String {
        return "\(color), \(number)"
    }
}
