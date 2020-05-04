//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

struct ParameterizedContainerWrapper: ContainerWrapperProtocol, CurrentScope {
    var isValid: Bool {
        return container != nil
    }
    weak var container: Container?
    let parameters: [ArgumentProtocol]

    init(_ container: Container, _ parameters: [ArgumentProtocol]) {
        self.container = container
        self.parameters = parameters
    }

    func resolveAnyOptional(_ serviceType: Any.Type, withArguments parameters: [ArgumentProtocol]?) throws -> Any? {

        if serviceType == CurrentScope.self {
            return self
        }

        if let parameter = resolveParameterByExactType(serviceType) {
            return parameter
        }
        
        guard let container = container else {
            throw ContainerError.invalidScope
        }
        
        return try container.resolveAnyOptional(serviceType, withArguments: parameters)
    }
    
    func resolveAll(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> [Any] {
        
        let allParameters = resolveAllParametersByExactType(serviceType)
        
        if !allParameters.isEmpty {
            return allParameters
        }
        
        guard let container = container else {
            throw ContainerError.invalidScope
        }
        
        return try container.resolveAll(serviceType, withArguments: arguments)
        
    }

    func resolveParameterByExactType(_ serviceType: Any.Type) -> Any? {
        for parameter in parameters {
            if let value = parameter.tryProvideValue(for: serviceType) {
                return value
            }
        }
        return nil
    }
    
    func resolveAllParametersByExactType(_ serviceType: Any.Type) -> [Any] {
        var result = [Any]()
        for parameter in parameters {
            if let value = parameter.tryProvideValue(for: serviceType) {
                result.append(value)
            }
        }
        return result
    }

    func getContainer() throws -> Container {
        guard let container = container else {
            throw ContainerError.invalidScope
        }
        return container
    }
}
