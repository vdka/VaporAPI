import HTTP
import Vapor
import VaporMySQL
import MySQL

let mysql = try VaporMySQL.Provider(host: "127.0.0.1", user: "root", password: "", database: "vapor_db")

let drop = Droplet(preparations: [Product.self, User.self], initializedProviders: [mysql])

drop.resource("/products", ProductController.instance)

var authedUsers: [String: User] = [:]

let fieldRemovalMiddleware = FieldRemovalMiddleware(fields: ["hash", "salt", "password"])

drop.post("/authorize", handler: AuthController.respond)

drop.grouped("/user").group(fieldRemovalMiddleware) { drop in

  // User create is Unauthorized
  drop.post(handler: UserController.create)

  drop.group(AuthMiddleware.instance) { drop in

    drop.get(handler: UserController.index)
    drop.put(handler: UserController.modify)
    drop.delete(handler: UserController.delete)
  }
}

let port = drop.config["app", "port"].int ?? 80

drop.serve()

