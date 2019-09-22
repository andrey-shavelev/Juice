//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
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
