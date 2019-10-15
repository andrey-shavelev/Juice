//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

final class InstancePerDependencyRegistrationTests: XCTestCase {
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
