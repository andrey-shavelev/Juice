//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

final class ModuleRegistrationTests: XCTestCase {
    func testRegistersServicesFromModule() throws {
        let container = try Container { builder in
            builder.register(module: FruitModule())
        }
        
        XCTAssertNoThrow({
            let _ = try container.resolve(Apple.self) }
        )
    }
}

struct FruitModule : Module {
    func registerServices(into containerBuilder: ContainerBuilder) {
        containerBuilder.register(injectable: Apple.self)
            .instancePerDependency()
            .asSelf()
    }
}
