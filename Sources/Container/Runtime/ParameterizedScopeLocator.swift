//
// Created by Andrey Shavelev on 2019-07-28.
//

import Foundation

struct ParameterizedScopeLocator: ResolutionScopeLocator {
    let container: Container
    let parameters: [Parameter]

    init(container: Container, parameters: [Parameter]) {
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
