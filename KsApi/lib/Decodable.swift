import Argo

public extension Argo.Decodable {
  /**
   Decode a JSON dictionary into a `Decoded` type.

   - parameter json: A dictionary with string keys.

   - returns: A decoded value.
   */
  static func decodeJSONDictionary(_ json: [String: Any]) -> Decoded<DecodedType> {
    return Self.decode(JSON(json))
  }
}

public extension Swift.Decodable {
  /**
   Decode a JSON dictionary into a `Decoded` type.

   - parameter json: A dictionary with string keys.

   - returns: A decoded value.
   */
  static func decodeJSON(_ json: [AnyHashable: Any]) -> Result<Self, Error> {
    do {
      let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
      return decode(data)
    } catch {
      return .failure(error)
    }
  }
}

struct Failable<T: Swift.Decodable>: Swift.Decodable {
  let value: T?

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    value = try? container.decode(T.self)
  }
}
