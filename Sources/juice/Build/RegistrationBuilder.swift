//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import Foundation

protocol RegistrationBuilder {
    associatedtype Prototype: ServiceRegistrationPrototype
    
    var registrationPrototype: Prototype { get }
}

public extension RegistrationBuilder {
    
}
