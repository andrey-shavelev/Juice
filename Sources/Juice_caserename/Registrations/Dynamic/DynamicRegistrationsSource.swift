//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

protocol DynamicRegistrationsSource {
    func FindRegistration(forType type: Any.Type) -> ServiceRegistration?
}
