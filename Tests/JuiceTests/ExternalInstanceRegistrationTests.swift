//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

final class ExternalInstanceRegistrationTests: XCTestCase {

    func testRegistrationOfInstance() throws {
        let apple = Apple()
        
        let container = try Container { builder in
            builder.register(instance: apple)
                    .ownedByContainer()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Apple.self))

        let appleFromContainer = try container.resolve(Apple.self)

        XCTAssert(apple === appleFromContainer)
    }

    func testDoesNotKeepAReferenceToExternalInstanceIfOwnedExternally() throws {
        var orange: Orange? = Orange()

        let container = try Container { builder in
            builder.register(instance: orange!)
                    .ownedExternally()
                    .asSelf()
        }

        weak var weakReferenceToOrange = try container.resolve(Orange.self)

        XCTAssertNotNil(weakReferenceToOrange)

        orange = nil

        XCTAssertNil(weakReferenceToOrange)
    }

    func testKeepsAReferenceToExternalInstanceIfConfigured() throws {
        var orange: Orange? = Orange()

        let container = try Container { builder in
            builder.register(instance: orange!)
                    .ownedByContainer()
                    .asSelf()
        }

        weak var weakReferenceToOrange = try container.resolve(Orange.self)
        orange = nil

        XCTAssertNotNil(weakReferenceToOrange)
    }
}
