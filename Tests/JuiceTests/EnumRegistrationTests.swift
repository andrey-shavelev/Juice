//
//  File.swift
//  
//
//  Created by Andrey Shavelev on 03/05/2020.
//
import XCTest
import Juice

final class EnumRegistrationsTest: XCTestCase {
    
    func testCanRegisterAndResolveEnumValue() throws {
        let container = try Container { builder in
            builder.register(value: TestEnum.three)
                .as(TestEnum.self)
        }
        
        let actualValue = try container.resolve(TestEnum.self)
        
        XCTAssertEqual(TestEnum.three, actualValue)
    }
}
