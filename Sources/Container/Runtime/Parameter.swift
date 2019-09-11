//
// Created by Andrey Shavelev on 08/09/2019.
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