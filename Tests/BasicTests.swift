import XCTest
@testable import SwaggerParser

class BasicTests: XCTestCase {
    func testInitialization() throws {
        let jsonString = try fixture(named: "uber.json")
        let swagger: Swagger!
        do {
            swagger = try Swagger(from: jsonString)
        } catch {
            print(error)
            throw error
        }

        XCTAssertEqual(swagger.host?.absoluteString, "api.uber.com")
        testInformation(swagger.information)
        
        guard let type = swagger.definitions["Product"]?.type else {
            return XCTFail("Unexpectedly no product definition")
        }
        
        guard case let .object(schema) = type else {
            return XCTFail("Unexpectedly not a structure")
        }
        
        XCTAssertEqual(schema.allProperties, ["product_id", "description", "capacity", "display_name", "image"])
    }
}

private func testInformation(_ information: Information) {
    XCTAssertEqual(information.title, "Uber API")
    XCTAssertEqual(information.description, "Move your app forward with the Uber API")
    XCTAssertEqual(information.version, .subversion(1, .subversion(0, .version(0))))
}
