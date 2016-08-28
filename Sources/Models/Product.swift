import Vapor
import Fluent

enum Currency: String {
  case AUD
  case USD
  case GBP // LOL!
}

final class Product: Model {

  enum Status: String {
    case active, disabled
  }


  var id: Node?
  var name: String
  var status: Status = .active
  var summary: String?
  var minorUnits: Int
  var currency: Currency

  init(name: String, minorUnits: Int, currency: Currency) {
    self.name = name
    self.minorUnits = minorUnits
    self.currency = currency
  }

  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    name = try node.extract("name")
    status = try node.extract("status", transform: Status.init) ?? .active

    minorUnits = try node.extract("minorUnits")

    guard let currency = try node.extract("currencyCode", transform: Currency.init)
      else { throw Abort.badRequest }

    self.currency = currency
  }

  func makeNode() throws -> Node {
    return try Node(node: [
      "id": id,
      "name": name,
      "status": status.rawValue,
      "summary": summary,
      "minorUnits": minorUnits,
      "currencyCode": currency.rawValue
    ])
  }

  static func prepare(_ database: Database) throws {
    try database.create("products") {
      $0.id()
      $0.string("name")
      $0.string("status")
      $0.string("summary", optional: true)
      $0.int("minorUnits")
      $0.string("currencyCode")
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete("products")
  }
}
