import Foundation

protocol Laptop {
    func getDescription(from options: [Option]) -> String
    func getPrice(from options: [Option]) -> Decimal
}

struct Option {
    let name: String
    let description: String
    let price: Decimal
}
