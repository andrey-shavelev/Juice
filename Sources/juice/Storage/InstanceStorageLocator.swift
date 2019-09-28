//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol InstanceStorageLocator {
    func findStorage(matchingKey key: ScopeKey) -> InstanceStorage?
}
