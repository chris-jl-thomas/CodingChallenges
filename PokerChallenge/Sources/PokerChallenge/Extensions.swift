import Foundation

extension Sequence {
    public func pairwise() -> AnyIterator<(Element, Element)> {
        var it = makeIterator()
        guard var last_value = it.next() else { return AnyIterator{ return nil } }

        return AnyIterator {
            guard let value = it.next() else { return nil }
            defer { last_value = value }
            return (last_value, value)
        }
    }
}

extension Sequence {
    public func all(pass predicate: (Element) -> Bool) -> Bool {
        // If nothing is false, everything is true
        return !self.contains(where: { !predicate($0) })
    }
}

extension Sequence {
    public func passesForConsecutiveValues(_ predicate:(Element, Element) -> Bool) -> Bool {
        return pairwise().all(pass: predicate)
    }
}

extension Array where Element == Card {
    public func getOrderedHand() -> [Card] {
        Array(self
            .getOrdered()
            .prefix(5)
        )
    }
    
    public func getOrdered() -> [Card] {
        Array(self
            .sorted { $0.value.rawValue > $1.value.rawValue }
        )
    }
    
    public func orderBySuit() -> [Card] {
        Array(self
            .sorted { $0.suit.rawValue < $1.suit.rawValue }
        )
    }
}
