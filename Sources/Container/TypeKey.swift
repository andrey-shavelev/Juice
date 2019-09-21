//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

public struct TypeKey: Hashable {
    let type: Any.Type

    init(for type: Any.Type) {
        self.type = type
    }

    public static func ==(lhs: TypeKey, rhs: TypeKey) -> Bool {
        return lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self.type))
    }
}
