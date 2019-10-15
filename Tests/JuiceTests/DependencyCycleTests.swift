//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

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
        
        var actualError: ContainerError?
        
        do {
            let _ = try container.resolve(Yin.self)
        } catch let error as ContainerError {
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
        
        var actualError: ContainerError?
        
        do {
            let _ = try container.resolve(Chicken.self)
        } catch let error as ContainerError {
            actualError = error
        }
        
        XCTAssertNotNil(actualError)
    }
}
