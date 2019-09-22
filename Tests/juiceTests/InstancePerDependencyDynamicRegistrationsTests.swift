//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import XCTest
import juice

final class InstancePerDependencyDynamicRegistrationsTests: XCTestCase {
    func testRegistersAndResolvesSingleInstanceService() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                    .instancePerDependency()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Apple.self))

        let firstApple = try container.resolve(Apple.self)
        let secondApple = try container.resolve(Apple.self)

        XCTAssert(firstApple !== secondApple)
    }
}
