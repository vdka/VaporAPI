
import HTTP
import Vapor
import Routing

extension Abort {
  static let unauthorized = Abort.custom(status: .unauthorized, message: "You are not authorized!")
}

struct UserController {

  static func index(request: Request) throws -> ResponseRepresentable {
    guard let user = request.storage["user"] as? User else { throw Abort.unauthorized }

    return user
  }

  static func create(request: Request) throws -> ResponseRepresentable {
    guard
      let name = request.data["name"].string,
      let email = request.data["email"].string,
      let password = request.data["password"].string
      else { throw Abort.badRequest }

    var user = try User(name: name, email: email, password: password)

    do {
      try user.save()
    } catch {

      // FIXME: Matching a string here is bad.
      let errorString = String(error)
      guard errorString.contains("Duplicate") && errorString.contains("email") else { throw error }

      throw Abort.custom(status: .conflict, message: "The email: \(email) is already registered with this service")
    }

    return user
  }

  static func modify(request: Request) throws -> ResponseRepresentable {
    guard var user = request.storage["user"] as? User else { throw Abort.unauthorized }

    request.data["name"].string.ifPresent { user.name = $0 }
    request.data["email"].string.ifPresent { user.email = $0 }

    try user.save()

    return user
  }

  static func delete(request: Request) throws -> ResponseRepresentable {
    guard let user = request.storage["user"] as? User else { throw Abort.unauthorized }

    try user.delete()
    return try Response(status: .ok, json: JSON(["success": true]))
  }
}
