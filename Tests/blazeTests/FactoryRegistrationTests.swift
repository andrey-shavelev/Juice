//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import XCTest
import blaze

final class FactoryRegistrationsTests: XCTestCase {
    func testRegisterAndResolveSingleInstanceCreatedByFactory() throws {
        let container = try Container { builder in

            builder.register { scope in
                        Apple()
                    }
                    .singleInstance()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Apple.self))
    }

    func testRegisterAndResolveInstancePerDependencyCreatedByFactory() throws {
        let container = try Container { builder in

            builder.register { scope in
                        Apple()
                    }
                    .instancePerDependency()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Apple.self))

        let firstApple = try container.resolve(Apple.self)
        let secondApple = try container.resolve(Apple.self)

        XCTAssert(firstApple !== secondApple)
    }
}
