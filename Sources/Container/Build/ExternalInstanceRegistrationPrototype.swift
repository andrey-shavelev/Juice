//
// Created by Andrey Shavelev on 2019-08-04.
//

import Foundation

class ExternalInstanceRegistrationPrototype<Type: AnyObject>: ServiceRegistrationPrototype {

    var services = [Any.Type]()
    let instance: Type
    var ownedByContainer = false

    init(instance: Type) {
        self.instance = instance
    }

    func build() -> ServiceRegistration {
        if (ownedByContainer) {
            return OwnedExternalInstanceRegistration(instance: self.instance)
        }

        return UnownedExternalInstanceRegistration(instance: self.instance)
    }
}
