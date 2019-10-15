//
// Copyright © 2019 Juice Project. All rights reserved.
//

struct ScopeLocator: ResolutionScopeLocator {
    let container: Container

    init(_ container: Container) {
        self.container = container
    }

    func findScope(matchingKey key: ScopeKey) -> Scope? {
        guard let actualContainer = container.findContainer(matchingKey: key) else {
            return nil
        }

        return ContainerWrapper(actualContainer)
    }
}
