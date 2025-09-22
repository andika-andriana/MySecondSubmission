import Combine

public protocol UseCase {
  associatedtype Request
  associatedtype Response
  func execute(_ request: Request) -> Response
}

public extension UseCase where Request == Void {
  func execute() -> Response {
    execute(())
  }
}

public struct AnyUseCase<Request, Response>: UseCase {
  private let _execute: (Request) -> Response

  public init<T: UseCase>(_ useCase: T) where T.Request == Request, T.Response == Response {
    _execute = useCase.execute
  }

  public func execute(_ request: Request) -> Response {
    _execute(request)
  }
}

public protocol PublisherUseCase: UseCase where Response: Publisher {}

public extension PublisherUseCase {
  func callAsFunction(_ request: Request) -> Response {
    execute(request)
  }
}

public struct AnyPublisherUseCase<Request, Output, Failure: Error>: PublisherUseCase {
  public typealias Response = AnyPublisher<Output, Failure>

  private let _execute: (Request) -> Response

  public init<T: PublisherUseCase>(
    _ useCase: T
  ) where T.Request == Request,
          T.Response.Output == Output,
          T.Response.Failure == Failure {
    _execute = { request in
      useCase.execute(request).eraseToAnyPublisher()
    }
  }

  public func execute(_ request: Request) -> Response {
    _execute(request)
  }
}

public enum NoRequest {
  public static let value: Void = ()
}
