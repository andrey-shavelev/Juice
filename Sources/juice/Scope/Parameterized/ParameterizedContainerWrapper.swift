//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

struct ParameterizedContainerWrapper: CurrentScope {
    var isValid: Bool {
        return container?.isValid == true
    }
    weak var container: Container?
    let parameters: [ParameterProtocol]

    init(_ container: Container, _ parameters: [ParameterProtocol]) {
        self.container = container
        self.parameters = parameters
    }

    func resolveAnyOptional(_ serviceType: Any.Type, withParameters parameters: [ParameterProtocol]?) throws -> Any? {

        if serviceType == CurrentScope.self {
            return self
        }

        if let parameter = resolveParameterByExactType(serviceType) {
            return parameter
        }
        
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }
        
        return try container.resolveAnyOptional(serviceType, withParameters: parameters)
    }

    func resolveParameterByExactType(_ serviceType: Any.Type) -> Any? {
        for parameter in parameters {
            if let value = parameter.tryProvideValue(for: serviceType) {
                return value
            }
        }
        return nil
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
