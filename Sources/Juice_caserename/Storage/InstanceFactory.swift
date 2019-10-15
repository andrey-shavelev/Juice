//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any
}
