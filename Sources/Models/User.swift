import Vapor
import Fluent
import BCrypt

final class User: Model {

  var id: Node?
  var name: String
  var email: String
  var hash: String

  init(name: String, email: String, password: String) throws {
    self.name   = name
    self.email  = email
    self.hash   = try BCrypt.hashPassword(password)
  }

  init(node: Node, in context: Context) throws {
    id    = try node.extract("id")
    name  = try node.extract("name")
    email = try node.extract("email")
    hash  = try node.extract("hash")
  }

  func makeNode() throws -> Node {
    return try Node(node:
      [
        "id": id,
        "name": name,
        "email": email,
        "hash": hash,
      ]
    )
  }

  static func prepare(_ database: Database) throws {
    try database.create("users") {
      $0.id()
      $0.string("name")
      $0.string("email")
      $0.string("hash")
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete("users")
  }
}
