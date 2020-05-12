//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

class ExternalInstanceRegistrationPrototype<Type: AnyObject>: RegistrationPrototype {

    var services = [ServiceKey]()
    let instance: Type
    var ownedByContainer: Bool?

    init(instance: Type) {
        self.instance = instance
    }

    func build() throws -> ServiceRegistration {
        guard let ownedByContainer = ownedByContainer else {
            throw ContainerError.missingOwnershipDefinition(componentType: Type.self)
        }

        if (ownedByContainer) {
            return OwnedExternalInstanceRegistration(instance: self.instance)
        }

        return UnownedExternalInstanceRegistration(instance: self.instance)
    }
}
