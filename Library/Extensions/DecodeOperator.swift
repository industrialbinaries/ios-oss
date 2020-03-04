import Foundation

precedencegroup DecodeOperatorPrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

infix operator <&?: DecodeOperatorPrecedence

func <&? <A: Decodable, B: CodingKey>(container: KeyedDecodingContainer<B>, key: B) -> A? {
  return try? container.decode(A.self, forKey: key)
}

infix operator <&: DecodeOperatorPrecedence

func <& <A: Decodable, B: CodingKey>(container: KeyedDecodingContainer<B>, key: B) throws -> A {
  return try container.decode(A.self, forKey: key)
}

infix operator <&|: DecodeOperatorPrecedence

func <&| <A: Decodable, B: CodingKey>(container: KeyedDecodingContainer<B>, key: B) -> [A] {
  return (try? container.decode([A].self, forKey: key))
    ?? []
}
