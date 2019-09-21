//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import Foundation

public struct Parameter {
    let value: Any
    let type: Any.Type

    public init(_ value: Any, as type: Any.Type){
        self.value = value
        self.type = type
    }

    public init<Type>(_ value: Type) {
        self.init(value, as: Type.self)
    }
}
