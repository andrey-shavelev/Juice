//
//  ParameterizedResolutionScope.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/06/2019.
//

import Foundation

class ParameterizedResolutionScope : Scope {
    let parent: Scope
    let parameters: [Any]
    
    init(parent: Scope, parameters: [Any]) {
        self.parent = parent
        self.parameters = parameters
    }
    
    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Any]) throws -> Service {
        if let parameter = resolveParameter(serviceType) {
            return parameter
        }
        return try parent.resolve(serviceType, withParameters: parameters)
    }    
    
    func resolve<TInstance>(_ serviceType: TInstance.Type) throws -> TInstance {
        if let parameter = resolveParameter(serviceType) {
            return parameter
        }
        return try parent.resolve(serviceType)
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
