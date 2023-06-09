// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "DDSViewModels",
	platforms: [.iOS(.v15), .tvOS(.v15),],
	products: [
		
		.library(
			name: "DDSViewModels",
			targets: ["DDSViewModels"]),
	],
	dependencies: [],
	targets: [
		
		.target(
			name: "DDSViewModels",
			dependencies: []),
		.testTarget(
			name: "DDSViewModelsTests",
			dependencies: ["DDSViewModels"]),	
	]
)
