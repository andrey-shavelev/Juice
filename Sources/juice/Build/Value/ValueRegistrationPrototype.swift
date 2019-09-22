//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
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
