//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol InstanceStorage {
    func getOrCreate(storageKey: StorageKey,
                               usingFactory factory: InstanceFactory,
                               withDependenciesFrom scope: Scope) throws -> Any

}
