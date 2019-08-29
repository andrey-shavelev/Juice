//
// Created by Andrey Shavelev on 2019-08-04.
//

import Foundation

class ExternalInstanceRegistrationPrototype<Type>: ServiceRegistrationPrototype {

    var services = [Any.Type]()
    let instance: Type
    let serviceProviderType: Any.Type

    init(instance: Type) {
        self.instance = instance
        self.serviceProviderType = Type.self
    }

    func build() -> ServiceRegistration {
        return ExternalInstanceRegistration<Type>(instance: self.instance)
    }
}
