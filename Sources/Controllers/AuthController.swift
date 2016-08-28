
import HTTP
import Vapor
import Fluent
import Foundation
import BCrypt

enum AuthController {

  static func respond(to request: Request) throws -> Response {
    guard
      let email = request.data["email"].string,
      let password = request.data["password"].string
      else { throw Abort.badRequest }

    guard let user = try User.query().filter("email", email).first() else { throw Abort.custom(status: .notFound, message: "User not found") }

    guard try BCrypt.verifyPassword(password, matchesHash: user.hash) else { throw Abort.unauthorized }

    let token = Date().timeIntervalSince1970.description

    authedUsers[token] = user

    return try Response(status: .created, json: JSON(["token": token]))
  }
}
