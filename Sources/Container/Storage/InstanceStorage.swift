//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

protocol InstanceStorage {
    func getOrCreate(storageKey: StorageKey,
                               usingFactory factory: InstanceFactory,
                               withDependenciesFrom scope: Scope) throws -> Any

}
