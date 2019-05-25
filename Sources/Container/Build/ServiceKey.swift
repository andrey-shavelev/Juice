//
//  ServiceKey.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public struct ServiceKey : Hashable {
    private let type: Any.Type
    
    init(for type: Any.Type) {
        self.type = type
    }
    
    public static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        return lhs.type == rhs.type
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self.type))
    }
}
