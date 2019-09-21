//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import Foundation

struct ParameterizedScopeLocator: ResolutionScopeLocator {
    let container: Container
    let parameters: [Parameter]

    init(_ container: Container, _ parameters: [Parameter]) {
        self.container = container
        self.parameters = parameters
    }

    func findScope(matchingKey key: ScopeKey) -> Scope? {
        guard let actualScope = container.findContainer(matchingKey: key) else {
            return nil
        }
        return ParameterizedResolutionScope(ResolutionScope(actualScope), parameters)
    }
}
