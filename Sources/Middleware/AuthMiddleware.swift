
import Vapor
import HTTP

struct AuthMiddleware: Middleware {

  static var instance = AuthMiddleware()

  func respond(to request: Request, chainingTo next: Responder) throws -> Response {

    guard
      let token = request.headers["token"],
      let user = authedUsers[token]
      else { throw Abort.unauthorized }

    request.storage["user"] = user

    return try next.respond(to: request)
  }
}
