//
// Created by Andrey Shavelev on 2019-08-11.
//

import Foundation

// TODO probably remove
class ContainerPrototype {

    var registrations: [TypeKey: ServiceRegistration] = [:]

    func addRegistration<Type>(serviceType: Type, registration: ServiceRegistration) {
        registrations[TypeKey(for: Type.self)] = registration;
    }
}
