
import HTTP
import Vapor

struct ProductController: ResourceRepresentable {

  static var instance = ProductController()

  func show(request: Request, item product: Product) throws -> ResponseRepresentable {
    return product
  }

  func index(request: Request) throws -> ResponseRepresentable {
    return try JSON(Product.all())
  }

  func create(request: Request) throws -> ResponseRepresentable {
    guard
      let name = request.data["name"].string,
      let minorUnits = request.data["minorUnits"].int,
      let currencyCode = request.data["currencyCode"].string,
      let currency = Currency(rawValue: currencyCode)
      else { throw Abort.badRequest }

    var product = Product(name: name, minorUnits: minorUnits, currency: currency)

    try product.save()

    return product
  }

  func modify(request: Request, product: Product) throws -> ResponseRepresentable {

    request.data["name"].string.ifPresent { product.name = $0 }
    if let currency = Currency(rawValue: request.data["currencyCode"].string ?? "") {
      product.currency = currency
    }
    request.data["minorUnits"].int.ifPresent { product.minorUnits = $0 }

    var product = product
    try product.save()

    return product
  }

  func delete(request: Request, product: Product) throws -> ResponseRepresentable {

    try product.delete()
    return try Response(status: .ok, json: JSON(["success": true]))
  }

  func makeResource() -> Resource<Product> {
    return Resource(index: index, store: create, show: show, modify: modify, destroy: delete)
  }
}
