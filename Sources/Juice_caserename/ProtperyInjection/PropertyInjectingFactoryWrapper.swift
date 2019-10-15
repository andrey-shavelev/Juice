//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

class PropertyInjectingFactoryWrapper : InstanceFactory {
    let wrappedFactory: InstanceFactory
    let propertyInjectors: [PropertyInjector]

    init(_ wrappedFactory: InstanceFactory, _ propertyInjectors: [PropertyInjector]){
        self.wrappedFactory = wrappedFactory
        self.propertyInjectors = propertyInjectors
    }

    func create(withDependenciesFrom scope: Scope) throws -> Any {
        let instance = try wrappedFactory.create(withDependenciesFrom: scope)
        for propertyInjector in propertyInjectors {
            try propertyInjector.inject(into: instance, resolveFrom: scope)
        }
        return instance
    }
}
