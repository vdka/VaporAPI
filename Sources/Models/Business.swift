import Vapor
import Fluent

struct Business: Model {

  var id: Node?
  var email: String
  var phoneNumber: String
  var registeredName: String

  var tradingName: String?
  var useTradingName: Bool


  init(registeredName: String, tradingName: String?, useTradingName: Bool, email: String, phoneNumber: String) {

    self.email = email
    self.phoneNumber = phoneNumber
    self.registeredName = registeredName
    self.tradingName = tradingName
    self.useTradingName = useTradingName
  }

  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    email = try node.extract("email")
    phoneNumber = try node.extract("phoneNumber")
    registeredName = try node.extract("registeredName")
    tradingName = try node.extract("tradingName")
    useTradingName = try node.extract("useTradingName")
  }

  func makeNode() throws -> Node {
    return try Node(node:
      [
        "id": id,
        "email": email,
        "phoneNumber": phoneNumber,
        "registeredName": registeredName,
        "tradingName": tradingName,
        "useTradingName": useTradingName
      ]
    )
  }

  static func prepare(_ database: Database) throws {
    try database.create("business") {
      $0.id()
      $0.string("email")
      $0.string("phoneNumber")
      $0.string("registeredName")
      $0.string("tradingName", optional: true)
      $0.bool("useTradingName")
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete("business")
  }
}
