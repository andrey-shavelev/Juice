//
// Created by Andrey Shavelev on 29/08/2019.
//

import Foundation

class ValueRegistrationPrototype<Type> : ServiceRegistrationPrototype {

    var services = [Any.Type]()
    let value: Type

    init(value: Type) {
        self.value = value
    }

    func build() -> ServiceRegistration {
        return OwnedExternalInstanceRegistration(instance: self.value)
    }
}
