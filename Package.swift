
import PackageDescription

let package = Package(
    name: "Logical",
    dependencies: [
        .Package(url: "https://github.com/JadenGeller/Axiomatic.git", majorVersion: 1)
    ]
)
