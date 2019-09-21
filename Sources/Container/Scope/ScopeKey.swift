//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
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

    static func create(fromName name: String?) -> ScopeKey {
        if let name = name {
            return .named(name: name)
        } else {
            return .unique(key: UniqueScopeKey())
        }
    }
}
