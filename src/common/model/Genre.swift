import Foundation

final class Genre: MusicalEntity {
	// MARK: - Public properties
	// Albums list reference
	var albums = [Album]()

	// MARK: - Initializers
	override init(name: String) {
		super.init(name: name)
	}
}

extension Genre: CustomStringConvertible {
	var description: String {
		"Name: <\(name)>\nNumber of albums: <\(albums.count)>"
	}
}

extension Genre {
	static func == (lhs: Genre, rhs: Genre) -> Bool {
		lhs.name == rhs.name
	}
}
