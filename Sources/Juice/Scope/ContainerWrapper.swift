//
// Copyright © 2019 Juice Project. All rights reserved.
//

struct ContainerWrapper: ContainerWrapperProtocol, CurrentScope {
    weak var container: Container?

    init(_ container: Container) {
        self.container = container
    }

    var isValid: Bool {
        return container != nil
    }

    func resolveAnyOptional(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> Any? {
        if serviceType == CurrentScope.self {
            return self
        }

        return try getContainer().resolveAnyOptional(serviceType, withArguments: arguments)
    }
    
    func resolveAnyOptional<Key>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]?) throws -> Any? where Key : Hashable {
        try getContainer().resolveAnyOptional(serviceType, forKey: key, withArguments: arguments)
    }
    
    func resolveAll(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> [Any] {
        try getContainer().resolveAll(serviceType, withArguments: arguments)
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
}
