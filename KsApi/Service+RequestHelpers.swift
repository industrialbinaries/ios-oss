import Argo
import Foundation
import Prelude
import ReactiveExtensions
import ReactiveSwift

extension Service {
  private static let session = URLSession(configuration: .default)

  @available(*, deprecated, message: "Parse your data with Swift.Decodable `func decodeModel(_ json:)`")
  private func decodeModel<M: Argo.Decodable>(_ json: Any) ->
    SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
    return SignalProducer(value: json)
      .map { json in decode(json) as Decoded<M> }
      .flatMap(.concat) { (decoded: Decoded<M>) -> SignalProducer<M, ErrorEnvelope> in
        switch decoded {
        case let .success(value):
          return .init(value: value)
        case let .failure(error):
          print("Argo decoding model \(M.self) error: \(error)")
          return .init(error: .couldNotDecodeJSON(error))
        }
      }
  }

  private func decodeModel<M: Swift.Decodable>(_ json: Data) ->
    SignalProducer<M, ErrorEnvelope> {
      return SignalProducer(value: json)
        .map(decode)
        .flatMap(.concat) { (decoded: Result<M, Error>)  -> SignalProducer<M, ErrorEnvelope> in
        switch decoded {
        case let .success(value):
          return .init(value: value)
        case let .failure(error):
          print("Swift decoding model \(M.self) error: \(error)")
          return .init(error: .couldNotDecodeJSON(error))
        }
      }
  }

  private func decodeModels<M: Argo.Decodable>(_ json: Any)
    -> SignalProducer<[M], ErrorEnvelope> where M == M.DecodedType {
    return SignalProducer(value: json)
      .map { json in decode(json) as Decoded<[M]> }
      .flatMap(.concat) { (decoded: Decoded<[M]>) -> SignalProducer<[M], ErrorEnvelope> in
        switch decoded {
        case let .success(value):
          return .init(value: value)
        case let .failure(error):
          print("Argo decoding model error: \(error)")
          return .init(error: .couldNotDecodeJSON(error))
        }
      }
  }

  private func decodeModel<M: Argo.Decodable>(_ json: Any) ->
    SignalProducer<M?, ErrorEnvelope> where M == M.DecodedType {
    return SignalProducer(value: json)
      .map { json in decode(json) as M? }
  }

  private func decodeGraphModel<T: Swift.Decodable>(_ jsonData: Data) -> SignalProducer<T, GraphError> {
    return SignalProducer(value: jsonData)
      .flatMap { data -> SignalProducer<T, GraphError> in
        do {
          let decodedObject = try JSONDecoder().decode(GraphResponse<T>.self, from: data)

          print("🔵 [KsApi] Successfully Decoded Data")

          return .init(value: decodedObject.data)
        } catch {
          print("🔴 [KsApi] Failure - Decoding error: \(error.localizedDescription)")
          return .init(error: .jsonDecodingError(
            responseString: String(data: data, encoding: .utf8),
            error: error
          ))
        }
      }
  }

  // MARK: - Public Request Functions

  func fetch<A: Swift.Decodable>(query: NonEmptySet<Query>) -> SignalProducer<A, GraphError> {
    let queryString: String = Query.build(query)

    let request = self.preparedRequest(
      forURL: self.serverConfig.graphQLEndpointUrl,
      queryString: queryString
    )

    print("⚪️ [KsApi] Starting query:\n \(queryString)")
    return Service.session.rac_graphDataResponse(request)
      .flatMap(self.decodeGraphModel)
  }

  func applyMutation<A: Swift.Decodable, B: GraphMutation>(mutation: B) -> SignalProducer<A, GraphError> {
    do {
      let request = try self.preparedGraphRequest(
        forURL: self.serverConfig.graphQLEndpointUrl,
        queryString: mutation.description,
        input: mutation.input.toInputDictionary()
      )
      print("⚪️ [KsApi] Starting mutation:\n \(mutation.description)")
      print("⚪️ [KsApi] Input:\n \(mutation.input.toInputDictionary())")

      return Service.session.rac_graphDataResponse(request)
        .flatMap(self.decodeGraphModel)
    } catch {
      return SignalProducer(error: .invalidInput)
    }
  }

  @available(*, deprecated, message: "Parse your data with Swift.Decodable `func requestPagination(url:)`")
  func requestPagination<M: Argo.Decodable>(_ paginationUrl: String)
    -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
    guard let paginationUrl = URL(string: paginationUrl) else {
      return .init(error: .invalidPaginationUrl)
    }

    return Service.session.rac_JSONResponse(preparedRequest(forURL: paginationUrl))
      .flatMap(self.decodeModel)
  }

  func requestPagination<M: Swift.Decodable>(url paginationUrl: String)
    -> SignalProducer<M, ErrorEnvelope> {
      guard let paginationUrl = URL(string: paginationUrl) else {
        return .init(error: .invalidPaginationUrl)
      }

      return Service.session.rac_dataResponse(preparedRequest(forURL: paginationUrl))
        .flatMap(self.decodeModel)
  }

  @available(*, deprecated, message: "Parse your data with Swift.Decodable `func request(route:)`")
  func request<M: Argo.Decodable>(_ route: Route)
    -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
    let properties = route.requestProperties

    guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
      fatalError(
        "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
      )
    }

    return Service.session.rac_JSONResponse(
      preparedRequest(forURL: URL, method: properties.method, query: properties.query),
      uploading: properties.file.map { ($1, $0.rawValue) }
    )
    .flatMap(self.decodeModel)
  }

  func request<M: Swift.Decodable>(route: Route)
    -> SignalProducer<M, ErrorEnvelope> {

      let properties = route.requestProperties

      guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
        fatalError(
          "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
        )
      }

      return Service.session.rac_dataResponse(
        preparedRequest(forURL: URL, method: properties.method, query: properties.query),
        uploading: properties.file.map { ($1, $0.rawValue) }
      )
      .flatMap(self.decodeModel)
  }

  func request<M: Argo.Decodable>(_ route: Route)
    -> SignalProducer<[M], ErrorEnvelope> where M == M.DecodedType {
    let properties = route.requestProperties

    let url = self.serverConfig.apiBaseUrl.appendingPathComponent(properties.path)

    return Service.session.rac_JSONResponse(
      preparedRequest(forURL: url, method: properties.method, query: properties.query),
      uploading: properties.file.map { ($1, $0.rawValue) }
    )
    .flatMap(self.decodeModels)
  }

  func request<M: Argo.Decodable>(_ route: Route)
    -> SignalProducer<M?, ErrorEnvelope> where M == M.DecodedType {
    let properties = route.requestProperties

    guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
      fatalError(
        "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
      )
    }

    return Service.session.rac_JSONResponse(
      preparedRequest(forURL: URL, method: properties.method, query: properties.query),
      uploading: properties.file.map { ($1, $0.rawValue) }
    )
    .flatMap(self.decodeModel)
  }
}

func decode<T>(_ data: Data) -> Result<T, Error> where T: Swift.Decodable {
  do {
    let value = try JSONDecoder()
      .decode(T.self, from: data)
    return .success(value)
  } catch {
    return .failure(error)
  }
}

