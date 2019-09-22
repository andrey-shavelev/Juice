//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

class InstancePerScopeComponentFactoryWrapper: InstanceFactory {
    let wrappedFactory: InstanceFactory
    let componentType: Any.Type
    var locked = false
    
    init(_ wrappedFactory: InstanceFactory, _ componentType: Any.Type) {
        self.wrappedFactory = wrappedFactory
        self.componentType = componentType
    }
    
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        guard !locked else {
            throw ContainerRuntimeError.dependencyCycle(componentType: componentType)
        }
        
        locked = true
        defer {
            locked = false
        }
        
        return try wrappedFactory.create(withDependenciesFrom: scope)
    }
}
