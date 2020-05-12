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
        
        return try getContainer().resolveAnyOptional(serviceType, withArguments: parameters)
    }
    
    func resolveAnyOptional<Key>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]?) throws -> Any? where Key : Hashable {
        try getContainer().resolveAnyOptional(serviceType, withArguments: parameters)
    }
    
    func resolveAll(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> [Any] {
        let allParameters = resolveAllParametersByExactType(serviceType)
        
        guard allParameters.isEmpty else {
            return allParameters
        }
        
        return try getContainer().resolveAll(serviceType, withArguments: arguments)
    }
    
    func resolveAll<Key>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]?) throws -> [Any] where Key : Hashable {
        try getContainer().resolveAll(serviceType, forKey: key, withArguments: arguments)
    }
    
    func getContainer() throws -> Container {
        guard let container = container else {
            throw ContainerError.invalidScope
        }
        
        return container
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
}
