//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

import XCTest
import blaze

final class DependencyCycleTests: XCTestCase {
    func testThrowsContainerRuntimeErrorOnDependencyCycle() throws {
        let container = try Container { builder in
            builder.register(injectable: Yin.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: Yang.self)
                .singleInstance()
                .asSelf()
        }
        
        var actualError: ContainerRuntimeError?
        
        do {
            let _ = try container.resolve(Yin.self)
        } catch let error as ContainerRuntimeError {
            actualError = error
        }
        
        XCTAssertNotNil(actualError)
    }
    
    func testThrowsContainerRuntimeErrorOnDependencyCycleUsingPropertyInjection() throws {
        let container = try Container { builder in
            builder.register(injectable: Chicken.self)
                .singleInstance()
                .asSelf()
                .injectDependency(into: \.egg)
            builder.register(injectable: Egg.self)
                .singleInstance()
                .asSelf()
                .injectDependency(into: \.chicken)
        }
        
        var actualError: ContainerRuntimeError?
        
        do {
            let _ = try container.resolve(Chicken.self)
        } catch let error as ContainerRuntimeError {
            actualError = error
        }
        
        XCTAssertNotNil(actualError)
    }
}
