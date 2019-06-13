import Foundation

extension String {
	// MARK: Removal of characters
	func removing(charactersOf string: String) -> String {
		let characterSet = CharacterSet(charactersIn: string)
		let components = self.components(separatedBy: characterSet)
		return components.joined(separator: "")
	}

	subscript(_ range: CountableRange<Int>) -> String {
		let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
		let idx2 = index(startIndex, offsetBy: min(count, range.upperBound))
		return String(self[idx1..<idx2])
	}

	// MARK: - NULL check
	static func isNullOrEmpty(_ value: String?) -> Bool {
		return value == nil || (value?.isEmpty)!
	}

	static func isNullOrWhiteSpace(_ value: String?) -> Bool {
		return isNullOrEmpty(value) || value?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
	}

	func isEmptyOrWhiteSpace() -> Bool {
		return isEmpty || trimmingCharacters(in: .whitespacesAndNewlines).count == 0
	}

	static func random(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0...length - 1).map { _ in letters.randomElement()! })
	}

	// MARK: - Hash functions
	func sha256() -> String {
		var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
		if let data = data(using: String.Encoding.utf8) {
			CC_SHA256((data as NSData).bytes, CC_LONG(data.count), &digest)
		}

		var ret = ""
		for i in 0 ..< Int(CC_SHA256_DIGEST_LENGTH) {
			ret += String(format: "%02x", digest[i])
		}
		return ret
	}

	func djb2() -> Int32 {
		return utf8.reduce(5381) { ($0 << 5) &+ $0 &+ Int32($1) }
	}

	func fuzzySearch(withString searchString: String, diacriticSensitive: Bool = false, caseSensitive: Bool = false) -> Bool {
		if searchString.count == 0 || count == 0 {
			return false
		}

		if searchString.count > count {
			return false
		}

		var sourceString = self
		var searchWithWildcards = "*\(searchString)*"
		if searchWithWildcards.count > 3 {
			for i in stride(from: 2, through: searchString.count * 2, by: 2) {
				searchWithWildcards.insert("*", at: searchWithWildcards.index(searchWithWildcards.startIndex, offsetBy: i))
			}
		}

		// Not case sensitive
		if caseSensitive == false {
			sourceString = sourceString.lowercased()
			searchWithWildcards = searchWithWildcards.lowercased()
		}

		let predicate = diacriticSensitive ? NSPredicate(format: "SELF LIKE %@", searchWithWildcards) : NSPredicate(format: "SELF LIKE[d] %@", searchWithWildcards)
		return predicate.evaluate(with: sourceString)
	}
}

func NYXLocalizedString(_ key: String) -> String {
	return NSLocalizedString(key, comment: "")
}
