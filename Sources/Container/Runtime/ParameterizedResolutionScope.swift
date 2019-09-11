//
//  ParameterizedResolutionScope.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/06/2019.
//

import Foundation

struct ParameterizedResolutionScope: Scope {

    var isValid: Bool {
        return parentScope?.isValid == true
    }
    let parentScope: Scope?
    let parameters: [Parameter]

    init(_ parentScope: Scope, _ parameters: [Parameter]) {
        self.parentScope = parentScope
        self.parameters = parameters
    }

    func resolveAnyOptional(_ serviceType: Any.Type, withParameters parameters: [Parameter]?) throws -> Any? {
        if let parameter = resolveParameterByExactType(serviceType) {
            return parameter
        }
        guard let parentScope = parentScope else {
            throw ContainerRuntimeError.invalidScope()
        }
        return try parentScope.resolveAnyOptional(serviceType, withParameters: parameters)
    }

    func resolveParameterByExactType(_ serviceType: Any.Type) -> Any? {
        for parameter in parameters {
            if parameter.type == serviceType {
                return parameter.value
            }
        }
        return nil
    }
}
