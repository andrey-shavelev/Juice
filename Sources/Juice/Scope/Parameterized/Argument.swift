//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

public protocol ArgumentProtocol {
    func tryProvideValue(for type: Any.Type) -> Any?
}

public struct Argument<Type>: ArgumentProtocol {
    let value: Type

    public init(_ value: Type) {
        self.value = value
    }
    
    public func tryProvideValue(for type: Any.Type) -> Any? {
        if type == Type.self
        {
            return value
        }
        return nil
    }
}

public struct AnyArgument: ArgumentProtocol {
    let value: Any
    let type: Any.Type

    public init(_ value: Any, _ type: Any.Type){
        self.value = value
        self.type = type
    }
    
    public func tryProvideValue(for type: Any.Type) -> Any? {
        if type == self.type
        {
            return value
        }
        return nil
    }
}
