import Argo

public struct VoidEnvelope: Swift.Decodable {}

extension VoidEnvelope: Argo.Decodable {
  public static func decode(_: JSON) -> Decoded<VoidEnvelope> {
    return .success(VoidEnvelope())
  }
}
