//
// Created by Andrey Shavelev on 06/09/2019.
//

import Foundation

protocol DynamicRegistrationsSource {
    func FindRegistration(forType type: Any.Type) -> ServiceRegistration?
}
