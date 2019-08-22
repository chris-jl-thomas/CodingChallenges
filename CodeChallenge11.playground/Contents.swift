import UIKit

public struct Identifier<T, Value> {
    
    fileprivate let value: Value
    
    /// Initialize an identifier with a string.
    ///
    /// - Parameter identifier: The original string identifier.
    public init(_ identifier: Value) {
        self.value = identifier
    }
}

extension Identifier: Equatable where Value: Equatable {}

extension Identifier: Hashable where Value: Hashable {}

extension String {
    
    /// Initialize a string with a given identifier to use the raw string value,
    /// likely to be when constructing API requests.
    ///
    /// - Parameter identifier: The identifier.
    public init<T>(_ identifier: Identifier<T, String>) {
        self = identifier.value
    }
}

extension Int {
    
    /// Initialize an integer with a given identifier to use the raw integer
    /// value, likely to be when constructing API requests.
    ///
    /// - Parameter identifier: The identifier.
    public init<T>(_ identifier: Identifier<T, Int>) {
        self = identifier.value
    }
}

extension Identifier: ExpressibleByIntegerLiteral where T: Any, Value == Int {
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension Identifier: ExpressibleByUnicodeScalarLiteral where T: Any, Value == String {
    
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}

extension Identifier: ExpressibleByExtendedGraphemeClusterLiteral where T: Any, Value == String {
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

extension Identifier: ExpressibleByStringLiteral where T: Any, Value == String {
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Identifier: Comparable where Value: Comparable {
    
    // swiftlint:disable capitalized_method
    public static func < (lhs: Identifier<T, Value>, rhs: Identifier<T, Value>) -> Bool {
        // swiftlint:enable capitalized_method
        return lhs.value < rhs.value
    }
}

extension Identifier: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return String(describing: value)
    }
}



func fetchData() {
    
}

