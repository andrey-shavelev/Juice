//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

struct ContainerWrapper: Scope {
    weak var container: Container?

    init(_ container: Container) {
        self.container = container
    }

    public var isValid: Bool {
        return container != nil
    }

    func resolveAnyOptional(_ serviceType: Any.Type, withParameters parameters: [Parameter]?) throws -> Any? {
        
        if serviceType == Scope.self {
            return self
        }

        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }

        return try container.resolveAnyOptional(serviceType, withParameters: parameters)
    }
}
