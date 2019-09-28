//
// Copyright © 2019 Juice Project. All rights reserved.
//

struct ContainerWrapper: CurrentScope {
    weak var container: Container?

    init(_ container: Container) {
        self.container = container
    }

    public var isValid: Bool {
        return container != nil
    }

    func resolveAnyOptional(_ serviceType: Any.Type, withParameters parameters: [ParameterProtocol]?) throws -> Any? {
        
        if serviceType == CurrentScope.self {
            return self
        }

        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }

        return try container.resolveAnyOptional(serviceType, withParameters: parameters)
    }
    
    func createChildContainer() throws -> Container {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }

        return container.createChildContainer()
    }
    
    func createChildContainer(name: String?) throws -> Container {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }

        return container.createChildContainer(name: name)
    }
    
    func createChildContainer(_ buildFunc: (ContainerBuilder) -> Void) throws -> Container {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }

        return try container.createChildContainer(buildFunc)
    }
    
    func createChildContainer(name: String?, _ buildFunc: (ContainerBuilder) -> Void) throws -> Container {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }

        return try container.createChildContainer(name: name, buildFunc)
    }
}
