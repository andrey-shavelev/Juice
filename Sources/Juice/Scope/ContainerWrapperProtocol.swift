//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol ContainerWrapperProtocol {
    func getContainer() throws -> Container
}

extension ContainerWrapperProtocol {
    func createChildContainer() throws -> Container {
        return try getContainer().createChildContainer()
    }

    func createChildContainer(name: String?) throws -> Container {
        return try getContainer().createChildContainer(name: name)
    }

    func createChildContainer(_ buildFunc: (ContainerBuilder) -> Void) throws -> Container {
        return try getContainer().createChildContainer(buildFunc)
    }

    func createChildContainer(name: String?, _ buildFunc: (ContainerBuilder) -> Void) throws -> Container {
        return try getContainer().createChildContainer(name: name, buildFunc)
    }
}