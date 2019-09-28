//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

struct ParameterizedScopeLocator: ResolutionScopeLocator {
    let container: Container
    let parameters: [ParameterProtocol]

    init(_ container: Container, _ parameters: [ParameterProtocol]) {
        self.container = container
        self.parameters = parameters
    }

    func findScope(matchingKey key: ScopeKey) -> Scope? {
        guard let actualScope = container.findContainer(matchingKey: key) else {
            return nil
        }
        return ParameterizedContainerWrapper(actualScope, parameters)
    }
}
