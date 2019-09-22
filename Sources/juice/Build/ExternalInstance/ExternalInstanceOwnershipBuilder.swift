//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import Foundation

public struct ExternalInstanceOwnershipBuilder<Type: AnyObject> {
    let registrationPrototype: ExternalInstanceRegistrationPrototype<Type>

    internal init(_ registrationPrototype: ExternalInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    /// Tells container to keep strong reference to an instance.
    ///
    /// - Returns: Specialized builder to compleate registration.
    public func ownedByContainer() -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.ownedByContainer = true
        return ExternalInstanceRegistrationBuilder(registrationPrototype)
    }

    /// Tells container to keep unowned reference to an instance.
    ///
    /// - Returns: Specialized builder to compleate registration.
    public func ownedExternally() -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.ownedByContainer = false
        return ExternalInstanceRegistrationBuilder(registrationPrototype)
    }
}
