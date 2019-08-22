//
// Created by Andrey Shavelev on 2019-08-04.
//

import Foundation

class ExternalInstanceRegistrationPrototype<Type>: ServiceRegistrationPrototype {

    var services = [Any.Type]()
    let instance: Type

    init(instance: Type) {
        self.instance = instance
    }

    func build() -> ServiceRegistration {
        return ExternalInstanceRegistration<Type>(instance: self.instance)
    }
}
