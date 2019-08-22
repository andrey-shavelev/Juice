//
//  ScopeKey.swift
//  blaze
//
//  Created by Andrey Shavelev on 11/07/2019.
//

public enum ScopeKey {
    case any
    case unique(key: UniqueScopeKey)
    case named(name: String)

    func matches(_ otherKey: ScopeKey) -> Bool {
        switch (self, otherKey) {
        case (.any, _):
            return true
        case (_, .any):
            return true
        case let (.named(firstName), .named(secondName)):
            return firstName == secondName
        case let (.unique(firstKey), .unique(secondKey)):
            return firstKey === secondKey
        default:
            return false
        }
    }
}
