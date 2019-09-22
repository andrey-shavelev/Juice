//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

protocol ResolutionScopeLocator {
    func findScope(matchingKey key: ScopeKey) -> Scope?
}
