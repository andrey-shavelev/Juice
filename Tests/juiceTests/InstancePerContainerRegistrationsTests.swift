//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import juice

final class InstancePerContainerRegistrationsTests: XCTestCase {

    func testResolvesDifferentInstanceOfInstancePerScopeServiceForChildScope() throws {
        let container = try Container { builder in
            builder.register(injectable: Orange.self)
                    .instancePerContainer()
                    .asSelf()
        }

        let orangeFromRootScope = try container.resolve(Orange.self)
        let childScope = container.createChildContainer()
        let orangeFromChildScope = try childScope.resolve(Orange.self)

        XCTAssertFalse(orangeFromRootScope === orangeFromChildScope)
    }

    func testResolvesSameInstanceOfInstancePerScopeServiceWhenResolvedFromSameScope() throws {
        let container = try Container { builder in
            builder.register(injectable: Orange.self)
                    .instancePerContainer()
                    .asSelf()
        }

        let childScope = container.createChildContainer()

        let orange = try childScope.resolve(Orange.self)
        let sameOrange = try childScope.resolve(Orange.self)

        XCTAssertTrue(orange === sameOrange)
    }
}
