import UIKit

final class Album: MusicalEntity {
	// MARK: - Public properties
	// Album artist
	var artist: String = ""
	// Album genre
	var genre: String = ""
	// Album release date
	var year: String = ""
	// Album path
	var path: String?
	// Album tracks
	var tracks: [Track]?
	// Album UUID
	private(set) var uniqueIdentifier: String
	// Local URL for the cover
	private(set) lazy var localCoverURL: URL? = {
		guard let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last else { return nil }
		guard let coverDirectoryPath = Settings.shared.string(forKey: .coversDirectory) else { return nil }
		return cachesDirectoryURL.appendingPathComponent(coverDirectoryPath, isDirectory: true).appendingPathComponent(self.uniqueIdentifier + ".jpg")
	}()

	// MARK: - Initializers
	override init(name: String) {
		self.uniqueIdentifier = name.sha256()
		super.init(name: name)
	}

	init(name: String, path: String, artist: String, genre: String, year: String) {
		self.artist = artist
		self.genre = genre
		self.year = year
		self.path = path
		self.uniqueIdentifier = path.sha256()
		super.init(name: name)
	}

	// MARK: - Hashable
	override public func hash(into hasher: inout Hasher) {
		let value = name.djb2() ^ Int32(genre.hashValue) ^ Int32(year.hashValue)
		hasher.combine(value)
	}
}

extension Album: CustomStringConvertible {
	var description: String {
		"\nName: \(name)\nArtist: \(artist)\nGenre: \(genre)\nYear: \(year)\nPath: \(String(describing: path))\n"
	}
}

extension Album {
	static func == (lhs: Album, rhs: Album) -> Bool {
		lhs.name == rhs.name && lhs.artist == rhs.artist && lhs.year == rhs.year && lhs.genre == rhs.genre
	}
}
