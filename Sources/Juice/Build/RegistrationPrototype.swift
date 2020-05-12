//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

protocol RegistrationPrototype {
    func build() throws -> ServiceRegistration
    var services: [ServiceKey] { get set }
}
