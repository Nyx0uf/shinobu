import CoreGraphics

extension CGPoint {
	// MARK: - Initializers
	public init(_ x: CGFloat, _ y: CGFloat) {
		self.init(x: x, y: y)
	}

	// MARK: - Round / Ceil
	func ceilled() -> CGPoint {
		CGPoint(ceil(x), ceil(y))
	}
}
