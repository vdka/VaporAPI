import PackageDescription

let package = Package(
  name: "VaporAPI",
  dependencies: [
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 0, minor: 16),
    .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 0, minor: 4),
    .Package(url: "https://github.com/CryptoKitten/BCrypt.git", majorVersion: 0, minor: 10)
  ],
  exclude: [
    "Config",
    "Database",
    "Localization",
    "Public",
    "Resources",
    "Tests",
    ]
)

