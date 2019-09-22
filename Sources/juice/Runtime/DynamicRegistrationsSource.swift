//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import Foundation

protocol DynamicRegistrationsSource {
    func FindRegistration(forType type: Any.Type) -> ServiceRegistration?
}
