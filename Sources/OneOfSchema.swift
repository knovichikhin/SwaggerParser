
public struct OneOfSchema {
    
    /// The array of subschemas that are options for this schema.
    public let subschemas: [Schema]
    
    /// Determines whether or not the schema should be considered abstract. This
    /// can be used to indicate that a schema is an interface rather than a
    /// concrete model object.
    ///
    /// Corresponds to the boolean value for `x-abstract`. The default value is
    /// false.
    public let abstract: Bool
}

struct OneOfSchemaBuilder: Codable {
    let schemaBuilders: [SchemaBuilder]
    let abstract: Bool
    
    enum CodingKeys: String, CodingKey {
        case schemaBuilders = "oneOf"
        case abstract = "x-abstract"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.schemaBuilders = try values.decode([SchemaBuilder].self, forKey: .schemaBuilders)
        self.abstract = (try values.decodeIfPresent(Bool.self, forKey: .abstract)) ?? false
    }
}

extension OneOfSchemaBuilder: Builder {
    typealias Building = OneOfSchema
    
    func build(_ swagger: SwaggerBuilder) throws -> OneOfSchema {
        let subschemas = try schemaBuilders.map { try $0.build(swagger) }
        return OneOfSchema(subschemas: subschemas, abstract: self.abstract)
    }
}

