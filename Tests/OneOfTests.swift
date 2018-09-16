import XCTest
@testable import SwaggerParser

class OneOfTests: XCTestCase {
    func testOneOfSupport() throws {
        let jsonString = try fixture(named: "test_one_of.json")
        let swagger: Swagger!
        do {
            swagger = try Swagger(from: jsonString)
        } catch {
            print(error)
            throw error
        }
        
        guard
            let baseDefinition = swagger.definitions["TestOneOfBase"],
            case .object(let baseSchema) = baseDefinition.type else
        {
            return XCTFail("TestAllOfBase is not an object schema.")
        }
        
        validate(testAllOfBaseSchema: baseSchema)
        try validate(that: swagger.definitions, containsTestOneOfChild: "TestOneOfFoo", withPropertyNames: ["foo"])
        try validate(that: swagger.definitions, containsTestOneOfChild: "TestOneOfBar", withPropertyNames: ["bar"])
        
        guard
            let fooDefinition = swagger.definitions["TestOneOfFoo"],
            case .oneOf = fooDefinition.type else
        {
            return XCTFail("TestAllOfFoo is not an object schema.")
        }
        
        XCTAssertEqual(fooDefinition.metadata.description, "This is an OneOf description.")
    }
}
