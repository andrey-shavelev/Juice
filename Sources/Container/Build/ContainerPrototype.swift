//
// Created by Andrey Shavelev on 2019-08-11.
//

import Foundation

struct ContainerPrototype {
    var registrations: [TypeKey: ServiceRegistration] = [:]
    var dynamicRegistrationSources: [DynamicRegistrationsSource]
}
