//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

public struct ExternalInstanceOwnershipBuilder<Type: AnyObject> {
    let registrationPrototype: ExternalInstanceRegistrationPrototype<Type>

    internal init(_ registrationPrototype: ExternalInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    /// Tells the container to keep a strong reference to the external component.
    ///
    public func ownedByContainer() -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.ownedByContainer = true
        return ExternalInstanceRegistrationBuilder(registrationPrototype)
    }

    /// Tells the container to keep an unowned reference to the external component.
    ///
    public func ownedExternally() -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.ownedByContainer = false
        return ExternalInstanceRegistrationBuilder(registrationPrototype)
    }
}
