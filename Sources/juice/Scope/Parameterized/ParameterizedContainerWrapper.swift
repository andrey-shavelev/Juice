//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import Foundation

struct ParameterizedContainerWrapper: Scope {
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
            if parameter.type == serviceType {
                return parameter.value
            }
        }
        return nil
    }
}
