//
//  InstanceRegistrationTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 20/06/2019.
//

import XCTest
@testable import blaze

final class ExternalInstanceRegistrationsTests: XCTestCase {

    func testRegistrationOfInstance() throws {
        let apple = Apple()
        let container = try Container { builder in
            builder.register(instance: apple)
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Apple.self))

        let appleFromContainer = try container.resolve(Apple.self)

        XCTAssert(apple === appleFromContainer)
    }

    func testDoesNotKeepAReferenceToExternalInstanceByDefault() throws {
        var orange: Orange? = Orange()

        let container = try Container { builder in
            builder.register(instance: orange!)
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
                    .asSelf()
                    .ownedByContainer()
        }

        weak var weakReferenceToOrange = try container.resolve(Orange.self)
        orange = nil

        XCTAssertNotNil(weakReferenceToOrange)
    }
}
