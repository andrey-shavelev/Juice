//
// Created by Andrey Shavelev on 2019-08-04.
//

import Foundation

protocol ServiceRegistrationPrototype {

    func build() throws -> ServiceRegistration

    var services: [Any.Type] { get }
}
