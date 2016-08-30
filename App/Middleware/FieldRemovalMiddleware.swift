
import Vapor
import HTTP

/// Removes fields
struct FieldRemovalMiddleware: Middleware {

  var fields: [String]

  func respond(to request: Request, chainingTo next: Responder) throws -> Response {

    let response = try next.respond(to: request)

    for field in fields {
      response.json?[field] = nil
    }

    return response
  }
}
