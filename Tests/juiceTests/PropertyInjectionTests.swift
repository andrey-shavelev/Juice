//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import XCTest
import juice

final class PropertyInjectionTests: XCTestCase {

    func testInjectsDependenciesIntoProperties() throws {
        let container = try Container { builder in
            builder.register(injectable: Pear.self)
                    .singleInstance()
                    .asSelf()
                    .as(Fruit.self)
            builder.register(injectable: Ginger.self)
                    .singleInstance()
                    .as(Spice.self)
            builder.register(injectable: Jam.self)
                    .singleInstance()
                    .asSelf()
                    .injectDependency(into: \.fruit)
                    .injectDependency(into: \.spice)
        }

        XCTAssertNoThrow(try container.resolve(Jam.self))

        let jam = try container.resolve(Jam.self)
        let pear = try container.resolve(Pear.self)

        XCTAssert(pear === jam.fruit as! Pear)
        XCTAssert(jam.spice is Ginger)
    }
    
    func testOptionalPropertyInjection() throws {
        let container = try Container { builder in
            builder.register(injectable: Pear.self)
                    .singleInstance()
                    .asSelf()
                    .as(Fruit.self)
            builder.register(injectable: Jam.self)
                    .singleInstance()
                    .asSelf()
                    .injectDependency(into: \.fruit)
                    .injectOptionalDependency(into: \.spice)
        }
        
        XCTAssertNoThrow(try container.resolve(Jam.self))
        let jam = try container.resolve(Jam.self)
        XCTAssertNil(jam.spice)
    }
}
