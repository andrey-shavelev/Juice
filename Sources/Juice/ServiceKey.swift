//
// Copyright © 2019 Juice Project. All rights reserved.
//

struct ServiceKey: Hashable {
    let type: Any.Type
    let key: AnyHashable?

    init(type: Any.Type) {
        self.type = type
        self.key = nil
    }
    
    init<T: Hashable>(type: Any.Type, key: T) {
        self.type = type
        self.key = key
    }

    public static func ==(lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        return lhs.type == rhs.type
            && lhs.key == rhs.key
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self.type))
    }
}
