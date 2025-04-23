// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TextAdventureGame",
    products: [
        .executable(name: "TextAdventureGame", targets: ["TextAdventureGame"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "TextAdventureGame",
            dependencies: [],
            path: "Sources",
            resources: [
                .copy("TextAdventureGame/Resources/world.json"),
                .copy("TextAdventureGame/Resources/save.json")
            ]
        )
    ]
)