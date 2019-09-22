//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

protocol InstanceStorageLocator {
    func findStorage(matchingKey key: ScopeKey) -> InstanceStorage?
}
