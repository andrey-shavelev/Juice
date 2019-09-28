//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

protocol ServiceRegistrationPrototype {
    func build() throws -> ServiceRegistration
    var services: [Any.Type] { get set }
}
