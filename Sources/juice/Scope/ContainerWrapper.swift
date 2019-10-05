//
// Copyright © 2019 Juice Project. All rights reserved.
//

struct ContainerWrapper: ContainerWrapperProtocol, CurrentScope {
    weak var container: Container?

    init(_ container: Container) {
        self.container = container
    }

    public var isValid: Bool {
        return container != nil
    }

    func resolveAnyOptional(_ serviceType: Any.Type, withArguments parameters: [ArgumentProtocol]?) throws -> Any? {
        if serviceType == CurrentScope.self {
            return self
        }

        return try getContainer().resolveAnyOptional(serviceType, withArguments: parameters)
    }

    func getContainer() throws -> Container {
        guard let container = container else {
            throw ContainerError.invalidScope
        }
        return container
    }
}