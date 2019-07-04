//
//  ParameterizedResolutionScope.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/06/2019.
//

import Foundation

class ParameterizedResolutionScope : Scope {
    
    var isValid: Bool {
        return parentScope?.isValid == true
    }
    let parentScope: Scope?
    let parameters: [Any]
    
    init(parentScope: Scope, parameters: [Any]) {
        self.parentScope = parentScope
        self.parameters = parameters
    }
    
    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Any]) throws -> Service {
        guard let parentScope = parentScope else {
            throw ContainerRuntimeError.invalidScope()
        }
        guard parentScope.isValid else {
            throw ContainerRuntimeError.invalidScope()
        }

        if let parameter = resolveParameter(serviceType) {
            return parameter
        }
        
        return try parentScope.resolve(serviceType, withParameters: parameters)
    }    
    
    func resolve<TInstance>(_ serviceType: TInstance.Type) throws -> TInstance {
        guard let parentScope = parentScope else {
            throw ContainerRuntimeError.invalidScope()
        }
        guard parentScope.isValid else {
            throw ContainerRuntimeError.invalidScope()
        }

        if let parameter = resolveParameter(serviceType) {
            return parameter
        }
        
        return try parentScope.resolve(serviceType)
    }
    
    func resolveParameter<Parameter>(_ parameterType: Parameter.Type) -> Parameter? {
        for parameter in parameters {
            let typedParameter = parameter as? Parameter
            if typedParameter != nil {
                return typedParameter
            }
        }
        return nil
    }
    
}
