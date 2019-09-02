//
// Created by Andrey Shavelev on 02/09/2019.
//

import Foundation

class StorageKey: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func ==(lhs: StorageKey, rhs: StorageKey) -> Bool {
        return lhs === rhs
    }
}
