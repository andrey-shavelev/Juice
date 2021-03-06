//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

class ValueRegistrationPrototype<Type> : RegistrationPrototype {
    var services = [ServiceKey]()
    let value: Type

    init(value: Type) {
        self.value = value
    }

    func build() -> ServiceRegistration {
        return OwnedExternalInstanceRegistration(instance: self.value)
    }
}
