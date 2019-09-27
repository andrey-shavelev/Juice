//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import Foundation

public protocol ParameterProtocol {
    var value: Any { get }
    var type: Any.Type { get }
}

public struct Parameter<Type>: ParameterProtocol {
    public let value: Any
    public var type: Any.Type { Type.self }

    public init(_ value: Type){
        self.value = value
    }
}

public struct AnyParameter: ParameterProtocol {
    public let value: Any
    public let type: Any.Type

    public init(_ value: Any, _ type: Any.Type){
        self.value = value
        self.type = type
    }
}
