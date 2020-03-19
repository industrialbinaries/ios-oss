import Foundation

extension KeyedDecodingContainer {
  func decodeOptional<A: Decodable>(_ key: Key) -> A? {
    return try? decode(A.self, forKey: key)
  }

  func decode<A: Decodable>(_ key: Key) throws -> A {
    return try decode(A.self, forKey: key)
  }

  func decodeArray<A: Decodable>(_ key: Key) -> [A] {
    return (try? decode([A].self, forKey: key))
      ?? []
  }
}
