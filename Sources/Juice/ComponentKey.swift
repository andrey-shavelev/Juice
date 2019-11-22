//
// Copyright © 2019 Juice Project. All rights reserved.
//

public struct ComponentKey: Hashable {
    let type: Any.Type

    init(for type: Any.Type) {
        self.type = type
    }

    public static func ==(lhs: ComponentKey, rhs: ComponentKey) -> Bool {
        return lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self.type))
    }
}
