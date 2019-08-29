//
// Created by Andrey Shavelev on 29/08/2019.
//

import Foundation

class PropertyInjectingFactoryWrapper : InstanceFactory {
    let innerFactory: InstanceFactory
    let propertyInjectors: [PropertyInjector]

    init(innerFactory: InstanceFactory, propertyInjectors: [PropertyInjector]){
        self.innerFactory = innerFactory
        self.propertyInjectors = propertyInjectors
    }

    func create(withDependenciesFrom scope: Scope) throws -> Any {
        let instance = try innerFactory.create(withDependenciesFrom: scope)
        for propertyInjector in propertyInjectors {
            try propertyInjector.inject(into: instance, resolveFrom: scope)
        }
        return instance
    }
}
