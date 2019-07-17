import Foundation

// https://github.com/apple/swift-evolution/blob/master/proposals/0121-remove-optional-comparison-operators.md
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.

/// A type that can be compared using the relational operators <, <=, >=, and >.
///
/// - Parameters:
///   - lhs: A value to compare.
///   - rhs: Another value to compare.
/// - Returns: Returns a Boolean value indicating whether the value of the first argument is less than that of the second argument.
public func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?): return l < r
    case (nil, _?): return true
    default: return false }
}

/// A type that can be compared using the relational operators <, <=, >=, and >.
///
/// - Parameters:
///   - lhs: A value to compare.
///   - rhs: Another value to compare.
/// - Returns: Returns a Boolean value indicating whether the value of the first argument is greater than that of the second argument.
public func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


/// A type that can be compared for value equality.
///
/// - Parameters:
///   - lhs: A value to compare.
///   - rhs: Another value to compare.
/// - Returns: Returns a Boolean value indicating whether two values are equal.
public func == <T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l == r
    case (nil, nil):
        return true
    default:
        return false
    }
}
