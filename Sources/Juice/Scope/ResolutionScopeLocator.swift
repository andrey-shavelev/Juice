//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol ResolutionScopeLocator {
    func findScope(matchingKey key: ScopeKey) -> Scope?
}
