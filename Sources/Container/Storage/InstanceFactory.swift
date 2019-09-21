//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

protocol InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any
}
